# CLAUDE.md — Contesto Progetto Grimoire

## AMBIENTE DI SVILUPPO

- CachyOS (Arch-based), sviluppo in locale
- Vim 9.2 con ALE + flake8 per validazione PEP8
- DBeaver per ispezionare il DB (localhost:5432)
- Docker + Docker Compose v2+ (comando `docker compose`, non `docker-compose`)
- Python 3.14.6 (nel container)

---

## STACK

```
Backend:     Python 3.14 + FastAPI
Database:    PostgreSQL 17 + pgvector
ORM:         SQLAlchemy
Validazione: Pydantic
Config:      pydantic-settings (Settings centralizzato)
Container:   Docker + Docker Compose v2+
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
│   │   │   ├── config.py        ← Settings centralizzato (pydantic-settings)
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
├── secrets/                     ← file dei segreti, gitignorata (generata da set_dev_env.sh)
│   ├── postgres_password
│   └── secret_key
├── docker-compose.yml
├── docker-compose.override.yml  ← solo dev, aggiunge mock data
├── set_dev_env.sh               ← prepara l'ambiente di sviluppo (segreti + .env)
├── .env.development             ← config non sensibili, gitignorato
├── .env.example                 ← template config (solo valori non sensibili)
├── README.md                    ← quick start per chi clona
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

I segreti (`postgres_password`, `secret_key`) sono definiti come Docker secrets e
montati nei container sotto `/run/secrets/`. Il servizio `db` riceve la password
via `POSTGRES_PASSWORD_FILE` (supporto nativo dell'immagine Postgres).

### Comandi

```bash
# sviluppo con mock data
docker compose -f docker-compose.yml -f docker-compose.override.yml up -d

# sviluppo senza mock data
docker compose -f docker-compose.yml up -d

# rebuild completo con reset DB
docker compose -f docker-compose.yml -f docker-compose.override.yml down -v
docker compose -f docker-compose.yml -f docker-compose.override.yml up -d --build
```

---

## CONFIGURAZIONE E SEGRETI

La configurazione è separata in due canali distinti.

### Configurazioni non sensibili (`.env.development`)

Caricate come variabili d'ambiente dai container via `env_file`.

```
POSTGRES_USER=kbuser
POSTGRES_DB=knowledgebase
ACCESS_TOKEN_EXPIRE_MINUTES=30
ENVIRONMENT=development
EMBEDDING_PROVIDER=ollama
EMBEDDING_MODEL=nomic-embed-text
EMBEDDING_DIMENSIONS=768
OLLAMA_URL=http://ollama:11434
```

### Segreti (`secrets/`, montati in `/run/secrets/`)

Un file per segreto, contenente solo il valore (senza newline finale).
Generati da `set_dev_env.sh`, mai versionati.

```
secrets/postgres_password
secrets/secret_key
```

### Lettura nel codice

Tutta la configurazione è centralizzata in `app/config.py` (classe `Settings`,
pydantic-settings). I segreti vengono letti dalla secrets directory
`/run/secrets/`, le configurazioni dalle variabili d'ambiente. Il resto del
codice accede solo tramite l'oggetto `settings`, senza `os.getenv` sparsi.

Nota sulla precedenza: pydantic-settings dà priorità alle variabili d'ambiente
rispetto alla secrets directory. Per questo i segreti non devono mai comparire
anche nel `.env`, altrimenti l'ambiente vincerebbe sui file.

Campi obbligatori (nessun default, l'app non parte se mancano):
`postgres_password`, `secret_key`, `postgres_user`, `postgres_db`, `environment`.
`environment` è vincolato ai valori `development` o `production`.

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

- **JWT** con algoritmo HS256, scadenza configurabile via `ACCESS_TOKEN_EXPIRE_MINUTES`
- **bcrypt** per hashing password
- `SECRET_KEY` è un segreto: letto da `/run/secrets/secret_key`, obbligatorio
  (l'app non parte se manca)
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
    legge settings.embedding_provider
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
- Configurazione centralizzata in `app/config.py` — nessun `os.getenv` sparso nel codice
- I campi critici (segreti, credenziali DB, `environment`) sono obbligatori senza default:
  se mancano, `Settings` fallisce e l'app non parte
- Solo i parametri operativi innocui hanno un default nel codice (es. `ollama_url`,
  `embedding_model`) — restano comunque sovrascrivibili dall'ambiente
- Algoritmo di cifratura (`HS256`) hardcoded — scelta architetturale, non configurazione operativa

---

## PROSSIMI PASSI

1. **Chunking degli articoli** — CRITICO. Attualmente un solo embedding per
   articolo (`to_embedding_text()` = titolo + contenuto intero). Su contenuti
   lunghi il modello tronca e l'embedding diventa una media semantica poco
   utile. Serve: tabella `chunks` con FK all'articolo, embedding per chunk,
   ricerca sui chunk con deduplica per articolo, revisione dell'hybrid search
2. **Markdown per gli articoli** — formato del campo `content`, rendering, e
   uso della struttura (sezioni, heading) come guida per il chunking semantico
3. **`set_prod_env.sh`** — script per l'ambiente di produzione (segreti non
   rigenerati a ogni run, `ENVIRONMENT=production`, niente mock data)
4. **Frontend React** — consuma tutte le API
5. **Deploy** — Railway o Render con CI/CD da GitHub
6. **Alembic** — migration per cambi schema in produzione
7. **Ruoli utente** — campo `is_admin` per proteggere endpoint admin
8. **Refresh token** — per gestione logout e revoca sessioni

---

## NOTE TECNICHE IMPORTANTI

- `entities.py` → classi SQLAlchemy (ORM, mapping tabelle DB)
- `models.py` → classi Pydantic (API, validazione input/output)
- `database.py` → engine, SessionLocal, Base, get_db
- `config.py` → Settings centralizzato, unica fonte di configurazione
- `auth.py` → logica JWT e bcrypt, NON importa `entities` direttamente
- `permissions.py` → duck typing, nessun import di entities necessario
- `embedding/` → client Ollama, stesso pattern di `database.py` per PostgreSQL
- `settings` in `config.py` è istanziato a livello di modulo: costruito una volta al primo import, condiviso da tutti i moduli
- pydantic-settings dà priorità all'ambiente sulla secrets directory — un segreto non deve mai stare in entrambi
- I file dei segreti non devono avere newline finale: generarli con `printf '%s'`, non con `echo` o redirezione diretta
- Cambiare un segreto già usato da un DB inizializzato richiede `down -v` — Postgres imposta la password solo al primo init del volume
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
