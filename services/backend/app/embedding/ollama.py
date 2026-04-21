import os
import httpx
from app.embedding.base import EmbeddingService


class OllamaEmbeddingService(EmbeddingService):

    def __init__(self):
        self.url = os.getenv("OLLAMA_URL", "http://ollama:11434")
        self.model = os.getenv("EMBEDDING_MODEL", "nomic-embed-text")

    def embed(self, text: str) -> list[float]:
        response = httpx.post(
            f"{self.url}/api/embeddings",
            json={"model": self.model, "prompt": text}
        )
        response.raise_for_status()
        return response.json()["embedding"]
