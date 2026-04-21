import os
from app.embedding.base import EmbeddingService
from app.embedding.ollama import OllamaEmbeddingService


def get_embedding_service() -> EmbeddingService:
    provider = os.getenv("EMBEDDING_PROVIDER", "ollama")

    if provider == "ollama":
        return OllamaEmbeddingService()

    raise ValueError(f"Provider embedding non supportato: {provider}")
