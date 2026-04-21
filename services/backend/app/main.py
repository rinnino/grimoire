from fastapi import FastAPI, HTTPException, Depends, Request
from fastapi.responses import JSONResponse
from fastapi.security import OAuth2PasswordRequestForm
from sqlalchemy import func, text
from sqlalchemy.orm import Session
from sqlalchemy.exc import OperationalError
from app.database import get_db
from app import entities, models, auth, permissions
from app.auth import get_current_user
from app.embedding.factory import get_embedding_service
from contextlib import asynccontextmanager
import asyncio
import os


@asynccontextmanager
async def lifespan(app: FastAPI):
    if os.getenv("ENVIRONMENT") == "development":
        await _dev_reindex()
    yield


async def _dev_reindex():
    while True:
        try:
            embedding_service.embed("warmup")
            break
        except Exception:
            await asyncio.sleep(5)
    db = next(get_db())
    try:
        articles = (db.query(entities.Article)
                    .filter(entities.Article.embedding.is_(None))
                    .all())
        for article in articles:
            article.embedding = embedding_service.embed(
                    article.to_embedding_text())
            db.commit()
    finally:
        db.close()


app = FastAPI(lifespan=lifespan)
embedding_service = get_embedding_service()


@app.exception_handler(OperationalError)
def db_error_handler(request: Request, exc: OperationalError):
    return JSONResponse(
            status_code=503,
            content={"detail": "Database not available"}
    )


@app.get("/")
def root():
    return {"message": "Knowledge Base API"}


@app.get("/health")
def health():
    return {"status": "ok"}


@app.get("/articles", response_model=list[models.ArticleResponse])
def get_articles(
    page: int = 1,
    limit: int = 10,
    db: Session = Depends(get_db),
    current_user: dict = Depends(get_current_user)
):
    offset = (page - 1) * limit
    return db.query(entities.Article).offset(offset).limit(limit).all()


@app.get("/articles/search", response_model=list[models.ArticleResponse])
def search_articles(
    q: str,
    page: int = 1,
    limit: int = 10,
    db: Session = Depends(get_db),
    current_user: dict = Depends(get_current_user)
):
    offset = (page - 1) * limit
    query = func.plainto_tsquery('simple', q)
    return (db.query(entities.Article)
            .filter(entities.Article.search_vector.op('@@')(query))
            .order_by(
                func.ts_rank(entities.Article.search_vector, query).desc())
            .offset(offset)
            .limit(limit)
            .all()
            )


@app.get("/articles/semantic-search",
         response_model=list[models.ArticleSearchResponse])
def semantic_search_articles(
        q: str,
        page: int = 1,
        limit: int = 10,
        db: Session = Depends(get_db),
        current_user: dict = Depends(get_current_user)
        ):
    offset = (page - 1) * limit
    query_embedding = embedding_service.embed(q)
    distance = entities.Article.embedding.cosine_distance(query_embedding)
    results = (db.query(entities.Article, distance.label("distance"))
               .filter(entities.Article.embedding.is_not(None))
               .order_by(distance.asc())
               .offset(offset)
               .limit(limit)
               .all()
               )
    for article, dist in results:
        article.similarity = 1 - dist
    return [article for article, _ in results]


@app.get("/articles/hybrid-search",
         response_model=list[models.ArticleHybridSearchResponse])
def hybrid_search_articles(
        q: str,
        page: int = 1,
        limit: int = 10,
        candidates: int = 50,
        db: Session = Depends(get_db),
        current_user: dict = Depends(get_current_user)
        ):
    offset = (page - 1) * limit
    query_embedding = embedding_service.embed(q)

    sql = text("""
        WITH full_text AS (
            SELECT id,
                   ROW_NUMBER() OVER (
                       ORDER BY ts_rank(search_vector,
                                        plainto_tsquery('simple', :q)) DESC
                   ) AS rank
            FROM articles
            WHERE search_vector @@ plainto_tsquery('simple', :q)
            LIMIT :candidates
        ),
        semantic AS (
            SELECT id,
                   ROW_NUMBER() OVER (
                       ORDER BY embedding <=> CAST(:embedding AS vector) ASC
                   ) AS rank
            FROM articles
            WHERE embedding IS NOT NULL
            LIMIT :candidates
        ),
        rrf AS (
            SELECT
                COALESCE(ft.id, sem.id) AS id,
                COALESCE(1.0 / (60 + ft.rank), 0) +
                COALESCE(1.0 / (60 + sem.rank), 0) AS rrf_score
            FROM full_text ft
            FULL OUTER JOIN semantic sem ON ft.id = sem.id
        )
        SELECT a.id, a.title, a.content, a.author_id,
               a.tags, a.created_at, r.rrf_score
        FROM articles a
        JOIN rrf r ON a.id = r.id
        ORDER BY r.rrf_score DESC
        LIMIT :limit OFFSET :offset
    """)

    rows = db.execute(sql, {
        "q": q,
        "embedding": str(query_embedding),
        "limit": limit,
        "offset": offset,
        "candidates": candidates
    }).mappings().all()

    return [models.ArticleHybridSearchResponse(**row) for row in rows]


@app.get("/articles/{article_id}", response_model=models.ArticleResponse)
def get_article(article_id: int,
                db: Session = Depends(get_db),
                current_user: dict = Depends(get_current_user)
                ):
    article = (db.query(entities.Article)
               .filter(entities.Article.id == article_id)
               .first()
               )
    if not article:
        raise HTTPException(status_code=404, detail="Articolo non trovato")
    return article


@app.post("/articles", response_model=models.ArticleResponse)
def create_article(
        article: models.ArticleCreate,
        db: Session = Depends(get_db),
        current_user: dict = Depends(get_current_user)
        ):
    new_article = entities.Article(
            **article.model_dump(),
            author_id=current_user["id"],
    )
    new_article.embedding = embedding_service.embed(
            new_article.to_embedding_text())
    db.add(new_article)
    db.commit()
    db.refresh(new_article)
    return new_article


@app.delete("/articles/{article_id}")
def delete_article(article_id: int,
                   db: Session = Depends(get_db),
                   current_user: dict = Depends(get_current_user)):
    article = (
            db.query(entities.Article)
            .filter(entities.Article.id == article_id)
            .first()
            )
    if not article:
        raise HTTPException(status_code=404, detail="Articolo non trovato")
    if not permissions.is_article_owner(article, current_user):
        raise HTTPException(status_code=403, detail="Non Autorizzato")
    db.delete(article)
    db.commit()
    return {"message": "Articolo eliminato"}


@app.put("/articles/{article_id}", response_model=models.ArticleResponse)
def update_article(
        article_id: int,
        article_update: models.ArticleUpdate,
        db: Session = Depends(get_db),
        current_user: dict = Depends(get_current_user)
):
    article = (db.query(entities.Article)
               .filter(entities.Article.id == article_id)
               .first()
               )
    if not article:
        raise HTTPException(status_code=404, detail="Articolo non trovato")
    if not permissions.is_article_owner(article, current_user):
        raise HTTPException(status_code=403, detail="Non autorizzato")
    update_data = article_update.model_dump(exclude_unset=True)
    for field, value in update_data.items():
        setattr(article, field, value)
    db.commit()
    db.refresh(article)
    return article


@app.post("/auth/register", response_model=models.UserResponse)
def register(user: models.UserCreate, db: Session = Depends(get_db)):
    existing = (db.query(entities.User)
                .filter(
                    (entities.User.username == user.username) |
                    (entities.User.email == user.email)
                )
                .first()
                )
    if existing:
        raise HTTPException(
                status_code=400,
                detail="Username o email già esistenti")
    new_user = entities.User(
            username=user.username,
            email=user.email,
            password_hash=auth.hash_password(user.password)
    )
    db.add(new_user)
    db.commit()
    db.refresh(new_user)
    return new_user


@app.post("/auth/login", response_model=models.TokenResponse)
def login(credentials: models.LoginRequest, db: Session = Depends(get_db)):
    user = (db.query(entities.User)
            .filter(entities.User.username == credentials.username)
            .first()
            )
    if not auth.authenticate_user(user, credentials.password):
        raise HTTPException(
            status_code=401,
            detail="Credenziali non valide"
        )
    token = auth.create_access_token(data={
        "sub": str(user.id),
        "username": user.username
    })
    return models.TokenResponse(access_token=token, token_type="bearer")


if os.getenv("ENVIRONMENT") == "development":
    @app.post("/auth/token", response_model=models.TokenResponse)
    def token(
        form_data: OAuth2PasswordRequestForm = Depends(),
        db: Session = Depends(get_db)
    ):
        user = (db.query(entities.User)
                .filter(entities.User.username == form_data.username)
                .first()
                )
        if not auth.authenticate_user(user, form_data.password):
            raise HTTPException(
                status_code=401,
                detail="Credenziali non valide"
            )
        new_token = auth.create_access_token(data={
            "sub": str(user.id),
            "username": user.username
        })
        return models.TokenResponse(
                access_token=new_token,
                token_type="bearer")


@app.post("/admin/reindex")
def reindex_articles(
        db: Session = Depends(get_db),
        current_user: dict = Depends(get_current_user)
        ):
    articles = (db.query(entities.Article)
                .filter(entities.Article.embedding.is_(None))
                .all()
                )
    count = 0
    for article in articles:
        article.embedding = embedding_service.embed(
                article.to_embedding_text()
        )
        count += 1
    db.commit()
    return {"message": f"Reindicizzati {count} articoli"}
