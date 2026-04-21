import os
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, DeclarativeBase

DATABASE_URL = (
        f"postgresql://{os.getenv('POSTGRES_USER')}"
        f":{os.getenv('POSTGRES_PASSWORD')}"
        f"@db:5432/{os.getenv('POSTGRES_DB')}"
)


engine = create_engine(DATABASE_URL)

SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)


class Base(DeclarativeBase):
    pass


def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
