# CavesSK — Backend Setup

FastAPI + PostgreSQL (TimescaleDB + PostGIS) + Keycloak, all running locally via Docker.

---

## Services

| Service   | URL                              | Credentials       |
|-----------|----------------------------------|-------------------|
| FastAPI   | http://localhost:8000/docs       | —                 |
| Keycloak  | http://localhost:8081/admin      | admin / admin     |
| Adminer   | http://localhost:8080            | see below         |
| Mailpit   | http://localhost:8025            | —                 |

**Adminer login:** System `PostgreSQL` · Server `postgres` · User `caves` · Password `cavespass` · DB `cavesdb`

---

## Project structure

```
py-fastapi-pg-jsonb-sample/
├── app/
│   ├── main.py          ← FastAPI app, CORS, router registration
│   ├── auth.py          ← JWT validation, roles, email_verified check
│   ├── database.py      ← SQLAlchemy engine + session
│   ├── models.py        ← Cave, Event ORM models (JSONB columns)
│   ├── schemas.py       ← Pydantic schemas
│   └── routers/
│       ├── caves.py     ← GET /caves
│       └── events.py   ← CRUD /events with role-based filtering
├── keycloak-import/
│   └── realm-export.json   ← realm config (import on first start)
├── postgres-init/
│   ├── 01-keycloak.sql     ← creates keycloak DB + user
│   ├── 02-schema.sql       ← caves + events tables, enables timescaledb + postgis
│   ├── 03-events.sql       ← seed cave data
│   └── 04-sensors.sql      ← sensors table, hypertable, hourly aggregate, seed sensors
├── seed_sensors.py          ← fake sensor data generator (see timescale.md)
├── docker-compose.yml
└── requirements.txt
```

---

## First-time setup

**1. Start Docker services**
```powershell
docker compose up -d
```
Starts PostgreSQL, Keycloak, Adminer, and Mailpit. Keycloak auto-imports the realm from `keycloak-import/` on first start.

**2. Create and activate a virtual environment**
```powershell
python -m venv .venv
.\.venv\Scripts\Activate.ps1
```

If PowerShell blocks script execution:
```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy RemoteSigned
```

**3. Install dependencies**
```powershell
pip install -r requirements.txt
```

**4. Run the API**
```powershell
uvicorn app.main:app --reload
```

---

## Daily workflow

```powershell
docker compose up -d
.\.venv\Scripts\Activate.ps1
uvicorn app.main:app --reload
```

---

## Auth & roles

Keycloak realm: **caves** · Client: **caves-api** (backend) / **caves-web** (frontend SPA)

| Group       | Roles                                                        |
|-------------|--------------------------------------------------------------|
| admin       | admin, events:create, events:read, events:read_caver, events:read_scientific, caves:read |
| researcher  | events:create, events:read, events:read_caver, events:read_scientific, caves:read |
| caver       | events:create, events:read, events:read_caver, caves:read    |
| visitor     | events:read, caves:read  ← default for new registrations    |

New users must verify their email before they can log in. Verification emails are caught by **Mailpit** at http://localhost:8025.

To change a user's role: Keycloak Admin → Users → select user → Groups.

---

## Re-importing the realm

Required after changes to `realm-export.json`:

```powershell
docker compose down -v
docker compose up -d
```

> `-v` wipes the DB volume so the init scripts and realm import run fresh. Existing users will be lost.
