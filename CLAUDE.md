# CLAUDE.md — Contesto Progetto Grimoire

## AMBIENTE DI SVILUPPO

- Arch Linux su Hyper-V (8GB RAM, 4 core virtuali, Ryzen 3800X)
- IP statico 192.168.1.150, accesso via SSH
- Vim con flake8/ALE per validazione PEP8
- pgAdmin 4 su Windows per visualizzare il DB
- Python 3.14

---

## STACK

```
Backend:     Python 3.14 + FastAPI
Database:    PostgreSQL 17 + pgvector
ORM:         SQLAlchemy
Validazione: Pydantic
Container:   Docker + docker-compose
Frontend:    React (da fare)
AI:          Ollama + nomic-embed-text (locale, 768 dimensioni)
Deploy:      Railway o Render (da fare)
```

---

## STRUTTURA PROGETTO

```
grimoire/
├── db/
│   ├── 01_schema.sh         ← script bash che genera schema con variabili env
│   └── 02_mock_data.sql     ← mock data solo in sviluppo
├── services/
│   ├── backend/
│   │   ├── app/
│   │   │   ├── __init__.py
│   │   │   ├── main.py          ← FastAPI endpoints
│   │   │   ├── database.py      ← engine, SessionLocal, Base, get_db
│   │   │   ├── entities.py      ← modelli SQLAlchemy
│   │   │   ├── models.py        ← modelli Pydantic
│   │   │   ├── auth.py          ← JWT, bcrypt, get_current_user
│   │   │   ├── permissions.py   ← autorizzazione per risorsa
│   │   │   └── embedding/
│   │   │       ├── __init__.py
│   │   │       ├── base.py      ← classe astratta EmbeddingService (ABC)
│   │   │       ├── ollama.py    ← OllamaEmbeddingService (adapter)
│   │   │       └── factory.py   ← get_embedding_service() (Factory pattern)
│   │   ├── Dockerfile
│   │   ├── .dockerignore
│   │   └── requirements.txt
│   └── ollama/
│       ├── Dockerfile           ← FROM ollama/ollama + start.sh
│       └── start.sh             ← ollama serve + pull automatico modello
├── docker-compose.yml
├── docker-compose.override.yml  ← solo dev, aggiunge mock data
├── .env.development
├── .env.example
└── .gitignore
```

---

## SCHEMA DATABASE

```sql
CREATE EXTENSION IF NOT EXISTS vector;

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username TEXT UNIQUE NOT NULL,
    email TEXT UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE articles (
    id SERIAL PRIMARY KEY,
    title TEXT NOT NULL,
    content TEXT NOT NULL,
    author_id INT REFERENCES users(id),
    tags TEXT[] DEFAULT '{}',
    created_at TIMESTAMP DEFAULT NOW(),
    search_vector TSVECTOR,
    embedding VECTOR(768)        -- dimensioni da EMBEDDING_DIMENSIONS nel .env
);

CREATE INDEX articles_search_idx ON articles USING GIN(search_vector);

CREATE TRIGGER articles_search_update
BEFORE INSERT OR UPDATE ON articles
FOR EACH ROW EXECUTE FUNCTION
    tsvector_update_trigger(search_vector, 'pg_catalog.simple', title, content);
```

Note schema:
- `tags` è array nativo PostgreSQL
- `search_vector` popolato automaticamente dal trigger ad ogni INSERT/UPDATE
- `embedding` dimensioni configurabili via `EMBEDDING_DIMENSIONS` nel `.env`
- Lo schema è in `01_schema.sh` (bash) per supportare variabili d'ambiente

---

## DOCKER COMPOSE

Tre container:
- `knowledge-base-db` — PostgreSQL 17 + pgvector
- `knowledge-base-backend` — FastAPI
- `knowledge-base-ollama` — Ollama con pull automatico del modello

### Comandi

```bash
# sviluppo con mock data
docker-compose -f docker-compose.yml -f docker-compose.override.yml up -d

# sviluppo senza mock data (default)
docker-compose up -d

# rebuild completo con reset DB
docker-compose -f docker-compose.yml -f docker-compose.override.yml down -v
docker-compose -f docker-compose.yml -f docker-compose.override.yml up -d --build
```

---

## VARIABILI D'AMBIENTE (.env.development)

```
POSTGRES_USER=kbuser
POSTGRES_PASSWORD=...
POSTGRES_DB=knowledgebase
SECRET_KEY=...
ACCESS_TOKEN_EXPIRE_MINUTES=30
ENVIRONMENT=development
EMBEDDING_PROVIDER=ollama
EMBEDDING_MODEL=nomic-embed-text
EMBEDDING_DIMENSIONS=768
OLLAMA_URL=http://ollama:11434
```

---

## ENDPOINTS IMPLEMENTATI

```
GET    /                       root
GET    /health                 health check

POST   /auth/register          registrazione (JSON)
POST   /auth/login             login (JSON) → JWT
POST   /auth/token             login (form) → JWT  [solo ENVIRONMENT=development]

GET    /articles               lista articoli paginata [autenticato]
GET    /articles/search        full-text search con ranking [autenticato]
GET    /articles/semantic-search  ricerca semantica con ranking per similarità coseno [autenticato]
GET    /articles/hybrid-search    ricerca ibrida full-text + semantica con RRF [autenticato]
GET    /articles/{id}          articolo singolo [autenticato]
POST   /articles               crea articolo + genera embedding [autenticato]
PUT    /articles/{id}          modifica articolo (partial update) [autenticato + autore]
DELETE /articles/{id}          elimina articolo [autenticato + autore]

POST   /admin/reindex          rigenera embedding articoli NULL [autenticato]
```

---

## AUTENTICAZIONE E AUTORIZZAZIONE

- **JWT** con algoritmo HS256, scadenza configurabile via `.env`
- **bcrypt** per hashing password (nessun default hardcoded)
- **Livelli di protezione:**
  - 401 — non autenticato
  - 403 — autenticato ma non autorizzato (non è l'autore)
- `author_id` mai hardcoded — sempre dal claim `sub` del token
- `/auth/token` (form OAuth2 per Swagger) abilitato solo in `ENVIRONMENT=development`

---

## EMBEDDING — ARCHITETTURA

Pattern **Strategy + Factory**:

```
EmbeddingService (ABC)          ← base.py
    └── OllamaEmbeddingService  ← ollama.py

get_embedding_service()         ← factory.py
    legge EMBEDDING_PROVIDER dal .env
    restituisce il provider giusto
```

Istanza singola a livello di modulo in `main.py`:
```python
embedding_service = get_embedding_service()
```

Thread-safe perché `OllamaEmbeddingService` è stateless — nessuno stato mutabile condiviso tra richieste.

Il testo embeddato è `f"{title} {content}"` — logica centralizzata in `Article.to_embedding_text()`.

---

## CONVENZIONI CODICE

- Moduli importati con nome esplicito: `from app import entities, models, auth, permissions`
- Uso: `entities.Article()`, `models.ArticleCreate`, `models.ArticleResponse`
- `from_attributes=True` nei modelli Pydantic di risposta
- `get_db()` usa `yield` per gestire ciclo di vita sessione con `Depends()`
- Nessun valore di default hardcoded per configurazioni critiche (`SECRET_KEY`, `EMBEDDING_DIMENSIONS`)
- Configurazioni operative sempre nel `.env`, mai nel codice sorgente
- Algoritmo di cifratura (`HS256`) hardcoded — scelta architetturale, non configurazione operativa

---

## PROSSIMI PASSI

1. dobbiamo fare il merge su main ( che punta al first commit ) della sessione di oggi
2. **Frontend React** — consuma tutte le API
3. **Deploy** — Railway o Render con CI/CD da GitHub
4. **Alembic** — migration per cambi schema in produzione
5. **Ruoli utente** — campo `is_admin` per proteggere endpoint admin
6. **Refresh token** — per gestione logout e revoca sessioni

---

## NOTE TECNICHE IMPORTANTI

- `entities.py` → classi SQLAlchemy (ORM, mapping tabelle DB)
- `models.py` → classi Pydantic (API, validazione input/output)
- `database.py` → engine, SessionLocal, Base, get_db
- `auth.py` → logica JWT e bcrypt, NON importa `entities` direttamente
- `permissions.py` → duck typing, nessun import di entities necessario
- `embedding/` → client Ollama, stesso pattern di `database.py` per PostgreSQL
- Full-text search usa `plainto_tsquery` (non `to_tsquery`) per gestire spazi
- Configurazione linguistica `simple` per testi tecnici misti italiano/inglese
- Route statiche (`/articles/search`) devono precedere route dinamiche (`/articles/{id}`)
- `down -v` distrugge i volumi — usare solo quando si vuole resettare il DB
- Il volume `ollama_data` persiste i modelli — non usare `-v` a meno che non serva rescaricarlo
- `ArticleSearchResponse` estende `ArticleResponse` aggiungendo `similarity: float` (1 - distanza coseno)
- Semantic search filtra articoli con `embedding IS NOT NULL` — `/admin/reindex` li allinea
- `lifespan` in `main.py` esegue reindex automatico all'avvio solo in `ENVIRONMENT=development`, attendendo che Ollama sia pronto prima di procedere
- Route `def` (sincrone) girano su thread pool automatico di FastAPI — corretto con SQLAlchemy sincrono
- Hybrid search usa Reciprocal Rank Fusion (RRF): combina rank full-text e semantico con 1/(60+rank), FULL OUTER JOIN tra le due CTE
- `candidates` (default 50) controlla quanti risultati considera ciascuna CTE prima della fusione
- Hybrid search usa `text()` di SQLAlchemy con prepared statement — query CTE troppo complessa per l'ORM
