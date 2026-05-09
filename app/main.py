from dotenv import load_dotenv
from fastapi.middleware.cors import CORSMiddleware

load_dotenv()

from fastapi import FastAPI

from app.routers import caves, surveys, entrances, survey_lines, protected_areas

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:5173"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(caves.router)
app.include_router(surveys.router)
app.include_router(entrances.router)
app.include_router(survey_lines.router)
app.include_router(protected_areas.router)


@app.get("/")
def root():
    return {"status": "ok"}


@app.get("/health")
def health():
    return {"status": "ok"}
