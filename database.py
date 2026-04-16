import os

from sqlalchemy import create_engine
from sqlalchemy.orm import declarative_base, sessionmaker

# Read database connection parts from environment variables.
# The defaults below are convenient for local development only.
DB_USER = os.getenv("DB_USER", "admin")
DB_PASSWORD = os.getenv("DB_PASSWORD", "admin")
DB_HOST = os.getenv("DB_HOST", "localhost")
DB_PORT = os.getenv("DB_PORT", "5432")
DB_NAME = os.getenv("DB_NAME", "cavesdb")

# Build the SQLAlchemy / psycopg connection string.
DATABASE_URL = (
    f"postgresql+psycopg://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}"
)

# Engine = SQLAlchemy's main database entry point.
# - pool_pre_ping=True checks pooled connections before using them
# - pool_size=5 keeps up to 5 regular open connections in the pool
# - max_overflow=10 allows temporary extra connections when traffic spikes
# - pool_timeout=30 waits up to 30 seconds for a free connection
# - echo=False avoids printing SQL in normal runtime logs
engine = create_engine(
    DATABASE_URL,
    pool_pre_ping=True,
    pool_size=5,
    max_overflow=10,
    pool_timeout=30,
    echo=False,
)

# SessionLocal creates one SQLAlchemy session when called.
# - autoflush=False means changes are not flushed automatically before each query
# - expire_on_commit=False keeps loaded values available after commit
SessionLocal = sessionmaker(
    bind=engine,
    autoflush=False,
    expire_on_commit=False,
)

# Base is the parent class for ORM models like Event.
Base = declarative_base()


def get_db():
    """FastAPI dependency: create one DB session per request and always close it."""
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
