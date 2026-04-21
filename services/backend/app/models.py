from pydantic import BaseModel
from datetime import datetime


# --- Article ---

class ArticleCreate(BaseModel):
    title: str
    content: str
    tags: list[str] = []


class ArticleResponse(BaseModel):
    id: int
    title: str
    content: str
    author_id: int
    tags: list[str]
    created_at: datetime

    class Config:
        from_attributes = True


class ArticleSearchResponse(ArticleResponse):
    similarity: float


class ArticleHybridSearchResponse(ArticleResponse):
    rrf_score: float


class ArticleUpdate(BaseModel):
    title: str | None = None
    content: str | None = None
    tags: list[str] | None = None


# --- User ---


class UserCreate(BaseModel):
    username: str
    email: str
    password: str


class UserResponse(BaseModel):
    id: int
    username: str
    email: str
    created_at: datetime

    class Config:
        from_attributes = True


class LoginRequest(BaseModel):
    username: str
    password: str


class TokenResponse(BaseModel):
    access_token: str
    token_type: str = "bearer"
