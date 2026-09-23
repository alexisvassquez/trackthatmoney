# Track That Money
# backend/juniper2_0/database/database.py
#
# Database connection and session setup.

import os
from dotenv import load_dotenv
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, DeclarativeBase

load_dotenv()

# Connect to Postgres
# Migrating from SQLite
DATABASE_URL = os.getenv("DATABASE_URL", "sqlite:///./ttm.db")

if DATABASE_URL.startswith("postgres://"):
    DATABASE_URL = DATABASE_URL.replace("postgres://", "postgresql+psycopg://", 1)
elif DATABASE_URL.startswith("postgresql://"):
    DATABASE_URL = DATABASE_URL.replace("postgresql://", "postgresql+psycopg://", 1)

connect_args = {"check_same_thread": False} if DATABASE_URL.startswith("sqlite") else {}

# Requests can be handled across multiple threads
engine = create_engine(
    DATABASE_URL,
    connect_args=connect_args,
    pool_pre_ping=True,
)

# SessionLocal is a factory
# Each request gets its own session via the get_db() dependency
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

# Base class for all SQLAlchemy table models.
# Models in modey.py inherit from this
class Base(DeclarativeBase):
    pass

def get_db():
    """
    FastAPI dependency that yields a database session per request.
    The sessions is always closed after the request completes,
    even if an exception is raised.
    """
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
