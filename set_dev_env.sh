#!/usr/bin/env bash
set -euo pipefail

# Move into the script's directory (so it works from any path)
cd "$(dirname "$0")"

# --- 1. Prerequisite check: Docker Compose v2+ ---
if ! docker compose version >/dev/null 2>&1; then
    echo "✗ Docker Compose v2+ not found."
    echo "  Install Docker and the Compose plugin, then try again."
    echo "  (The legacy 'docker-compose' binary is not supported.)"
    exit 1
fi
echo "✓ Docker Compose found: $(docker compose version --short)"

# --- 2. Generate .env.development ---
if [ -f .env.development ]; then
    echo "✓ .env.development already exists, leaving it untouched."
else
    cp .env.example .env.development
    sed -i "s|^POSTGRES_PASSWORD=.*|POSTGRES_PASSWORD=$(openssl rand -hex 24)|" .env.development
    sed -i "s|^SECRET_KEY=.*|SECRET_KEY=$(openssl rand -hex 32)|" .env.development
    echo "✓ .env.development created with generated secrets."
fi

# --- 3. Final message ---
cat <<'MSG'

Dev environment ready. Useful commands:

  Start (with mock data):
    docker compose -f docker-compose.yml -f docker-compose.override.yml up -d --build

  Stop (keep data):
    docker compose down

  Stop and wipe volumes (DB + Ollama model):
    docker compose down -v

  URLs once running:
    API / Swagger -> http://localhost:8000/docs
    PostgreSQL    -> localhost:5432
MSG
