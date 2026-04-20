# FastAPI + PostgreSQL + JSONB + Keycloak Local Demo

A minimal local setup for testing **FastAPI** with **PostgreSQL** and a **JSONB** column, using **Docker/Rancher Desktop** for services and **Adminer** for database inspection.

## What this project does

- Runs PostgreSQL locally in Docker
- Runs Adminer locally in Docker
- Runs Keycloak (identity & access management) locally in Docker
- Runs a FastAPI application locally on your machine
- Stores flexible JSON data in a PostgreSQL `JSONB` column
- Lets you test API endpoints from Swagger UI

---

## Prerequisites

- Python 3.12 installed
- Rancher Desktop or Docker Desktop running
- PowerShell terminal

---

## Project structure

Typical files in the project:

```text
fastapi-pg-jsonb-demo/
├─ app/
│  ├─ routers/
│  │  └─ events.py       ← all /events endpoints
│  ├─ main.py            ← app creation + router registration
│  ├─ database.py        ← SQLAlchemy engine + session
│  ├─ models.py          ← ORM models
│  ├─ schemas.py         ← Pydantic schemas
│  └─ auth.py            ← role extraction + serialization
├─ postgres-init/
│  └─ 01-keycloak.sql
├─ k8s/
│  └─ app.yaml
├─ .venv/
├─ docker-compose.yml
└─ requirements.txt
```

---

## 1. Start PostgreSQL, Adminer, and Keycloak

From the project folder:

```powershell
docker compose up -d
```

This starts three containers: `local-postgres`, `local-adminer`, and `local-keycloak`.

The `postgres-init/01-keycloak.sql` script runs automatically on first start and creates the `keycloak` database and user that Keycloak needs.

If you ever need to stop them:

```powershell
docker compose down
```

To check running containers:

```powershell
docker ps
```

---

## 2. Activate the Python virtual environment

```powershell
.\.venv\Scripts\Activate.ps1
```

If PowerShell blocks script execution:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy RemoteSigned
.\.venv\Scripts\Activate.ps1
```

When activation works, your prompt should start with:

```text
(.venv)
```

---

## 3. Install Python packages

If not installed yet:

```powershell
python -m pip install --upgrade pip
pip install fastapi "uvicorn[standard]" sqlalchemy "psycopg[binary]"
pip freeze > requirements.txt
```

---

## 4. Run the FastAPI application

```powershell
uvicorn app.main:app --reload
```

Expected local address:

```text
http://127.0.0.1:8000
```

---

## 5. Swagger UI

Open in browser:

```text
http://127.0.0.1:8000/docs
```

This is the interactive API documentation where you can:

- send `POST` requests
- test `GET` requests
- inspect request and response bodies

If the app is running, you should see endpoints such as:

- `GET /`
- `POST /events`
- `GET /events`
- `GET /events/by-kind/{kind}`
- `GET /events/longer-than/{min_length}` *(if you added this endpoint)*

---

## 6. Example JSON for `POST /events`

Use this in Swagger UI:

```json
{
  "name": "Demo cave",
  "payload": {
    "kind": "cave",
    "region": "Slovakia",
    "length_m": 1200,
    "tags": ["karst", "tourism"],
    "meta": {
      "protected": true,
      "difficulty": "medium",
      "secret": "asdawdasdaw"
    }
  }
}
```

---

## 7. Test JSONB filtering

### Filter by kind

Example endpoint:

```text
GET /events/by-kind/cave
```

### Filter by numeric value inside JSONB

If you added the endpoint for length:

```text
GET /events/longer-than/1000
```

This tests querying inside the PostgreSQL `JSONB` field.

---

## 8. Adminer

Open in browser:

```text
http://127.0.0.1:8080
```

Login values:

- **System**: `PostgreSQL`
- **Server**: `postgres`
- **Username**: `caves`
- **Password**: `cavespass`
- **Database**: `cavesdb`

After login:

1. open database `cavesdb`
2. open table `events`
3. inspect inserted rows

---

## 9. Keycloak

Open in browser:

```text
http://127.0.0.1:8081
```

Admin console:

```text
http://127.0.0.1:8081/admin
```

Login values:

- **Username**: `admin`
- **Password**: `admin`

Keycloak runs in development mode (`start-dev`) and stores its data in the `keycloak` database on the same PostgreSQL instance. The database and user are created automatically on first `docker compose up` via `postgres-init/01-keycloak.sql`.

---

## 10. Current database connection used by the app

Example connection string used in `database.py`:

```python
DATABASE_URL = "postgresql+psycopg://caves:cavespass@localhost:5432/cavesdb"
```

Notes:

- FastAPI runs on your host machine, so it connects to PostgreSQL via `localhost:5432`
- Adminer runs in Docker, so it uses the Docker service name `postgres`

---

## 11. Useful commands

### Start Docker services

```powershell
docker compose up -d
```

### Stop Docker services

```powershell
docker compose down
```

### Check containers

```powershell
docker ps
```

### Activate venv

```powershell
.\.venv\Scripts\Activate.ps1
```

### Run app

```powershell
uvicorn app.main:app --reload
```

### Save dependencies

```powershell
pip freeze > requirements.txt
```

---

## 12. Typical local flow

Each time you start working:

```powershell
docker compose up -d
.\.venv\Scripts\Activate.ps1
uvicorn app.main:app --reload
```

Then open:

- Swagger UI: `http://127.0.0.1:8000/docs`
- Adminer: `http://127.0.0.1:8080`
- Keycloak admin: `http://127.0.0.1:8081/admin`

---

## 13. Common issues

### PowerShell cannot activate the venv

Run:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy RemoteSigned
```

Then try activation again.

### Adminer does not open

Check:

```powershell
docker ps
```

Make sure the `adminer` container is running.

### Adminer login fails

Verify the values from `docker-compose.yml`.

### FastAPI cannot connect to PostgreSQL

Make sure:

- PostgreSQL container is running
- port `5432` is exposed
- `DATABASE_URL` points to `localhost:5432`

### Keycloak does not start

Keycloak depends on PostgreSQL. Make sure the `postgres` container is healthy first:

```powershell
docker ps
docker logs local-keycloak
```

If starting for the first time after a `docker compose down -v`, the init script re-creates the `keycloak` database automatically.

---

## 14. Next improvements

Possible next steps:

- move config into a `.env` file
- configure a Keycloak realm and client for the FastAPI app
- protect FastAPI endpoints with Keycloak JWT tokens
- add Alembic migrations
- add more JSONB queries
- add indexes for frequently queried JSONB fields
- split app into routers and services

