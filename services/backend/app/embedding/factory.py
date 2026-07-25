from app.config import settings
from app.embedding.base import EmbeddingService
from app.embedding.ollama import OllamaEmbeddingService


def get_embedding_service() -> EmbeddingService:
    provider = settings.embedding_provider

    if provider == "ollama":
        return OllamaEmbeddingService()

    raise ValueError(f"Provider embedding non supportato: {provider}")
