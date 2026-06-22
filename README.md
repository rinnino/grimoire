# Grimoire

Self-hosted knowledge base with full-text, semantic, and hybrid search.
Backend in FastAPI + PostgreSQL/pgvector, embeddings via local Ollama.

## Prerequisites

- Docker
- Docker Compose v2+

## Quick start

```bash
git clone https://github.com/rinnino/grimoire.git
cd grimoire
./set_dev_env.sh
docker compose -f docker-compose.yml -f docker-compose.override.yml up -d --build
```

`set_dev_env.sh` prepares a ready-to-run development/test environment: it
creates `.env.development` from `.env.example`, generating the required
secrets (`POSTGRES_PASSWORD`, `SECRET_KEY`) automatically so the stack works
out of the box. `.env.development` is the env file loaded by every service in
`docker-compose.yml`, which is why that exact filename is expected. The first
startup also downloads the Ollama embedding model, so it may take a while.

Once running:

- API / Swagger UI → http://localhost:8000/docs
- PostgreSQL → localhost:5432

## Useful commands

```bash
# Stop (keep data)
docker compose down

# Stop and wipe volumes (DB + Ollama model)
docker compose down -v
```

## Production

This Compose setup targets local development and testing only (bind-mounted
code, mock data, secrets in a local `.env` file). A production deployment will
work differently and is still a TODO. See the next steps in [CLAUDE.md](CLAUDE.md).

## Documentation

See [CLAUDE.md](CLAUDE.md) for architecture, database schema, and the full
endpoint reference.
