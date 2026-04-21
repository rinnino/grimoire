from sqlalchemy import Column, Integer, Text, ARRAY, TIMESTAMP, ForeignKey
from sqlalchemy.dialects.postgresql import TSVECTOR
from sqlalchemy.sql import func
from pgvector.sqlalchemy import Vector
from app.database import Base
import os


EMBEDDING_DIMENSIONS = int(os.getenv("EMBEDDING_DIMENSIONS"))


class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True)
    username = Column(Text, unique=True, nullable=False)
    email = Column(Text, unique=True, nullable=False)
    password_hash = Column(Text, nullable=False)
    created_at = Column(TIMESTAMP, server_default=func.now())


class Article(Base):
    __tablename__ = "articles"

    id = Column(Integer, primary_key=True)
    title = Column(Text, nullable=False)
    content = Column(Text, nullable=False)
    author_id = Column(Integer, ForeignKey("users.id"))
    tags = Column(ARRAY(Text), server_default="{}")
    created_at = Column(TIMESTAMP, server_default=func.now())
    search_vector = Column(TSVECTOR)
    embedding = Column(Vector(EMBEDDING_DIMENSIONS))

    def to_embedding_text(self) -> str:
        return f"{self.title} {self.content}"
