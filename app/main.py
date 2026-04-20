from dotenv import load_dotenv
load_dotenv()

from fastapi import FastAPI

from app.database import Base, engine
from app.routers import events

Base.metadata.create_all(bind=engine)

app = FastAPI()

app.include_router(events.router)


@app.get("/")
def root():
    return {"status": "ok"}


@app.get("/health")
def health():
    return {"status": "ok"}
