# Track That Money
# backend/juniper2_0/database/database.py
#
# Database connection and session setup.
# Uses SQLite via SQLAlchemy 2.0
# TODO: Swap DATABASE_URL for PostgreSQL / MySQL in prod

from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, DeclarativeBase

# SQLite file will be created at backend/juniper2_0/trackthatmoney.db
# on first run
DATABASE_URL = "sqlite:///./trackthatmoney.db"

# Requests can be handled across multiple threads
# Required for SQLite when used with FastAPI
engine = create_engine(
    DATABASE_URL,
    connect_args={"check_same_thread": False},
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
