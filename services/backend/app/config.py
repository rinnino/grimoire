from enum import Enum
from pydantic_settings import BaseSettings, SettingsConfigDict


class Environment(str, Enum):
    development = "development"
    production = "production"


class Settings(BaseSettings):
    model_config = SettingsConfigDict(
        secrets_dir="/run/secrets",
        case_sensitive=False,
    )

    # --- Segreti (letti da /run/secrets) ---
    postgres_password: str
    secret_key: str

    # --- Obbligatori da env (nessun default) ---
    postgres_user: str
    postgres_db: str
    environment: Environment

    # --- Configurazioni operative (con default) ---
    access_token_expire_minutes: int = 30
    embedding_provider: str = "ollama"
    embedding_model: str = "nomic-embed-text"
    embedding_dimensions: int = 768
    ollama_url: str = "http://ollama:11434"


settings = Settings()
