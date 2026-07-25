from app.config import settings
import httpx
from app.embedding.base import EmbeddingService


class OllamaEmbeddingService(EmbeddingService):

    def __init__(self):
        self.url = settings.ollama_url
        self.model = settings.embedding_model

    def embed(self, text: str) -> list[float]:
        response = httpx.post(
            f"{self.url}/api/embeddings",
            json={"model": self.model, "prompt": text}
        )
        response.raise_for_status()
        return response.json()["embedding"]
