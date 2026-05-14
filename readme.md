## Docker
read docker.md
## Backend

Create virtual environment:

```bash
python -m venv .venv
```

Activate on Windows PowerShell:

```bash
.venv\Scripts\Activate.ps1
```

Install dependencies:

```bash
pip install -r requirements.txt
```

Run FastAPI:

```bash
uvicorn app.main:app --reload
```

Open:

```text
http://localhost:8000/docs
```

Create venv (first time):
`python -m venv .venv`

Activate venv:
`.\.venv\Scripts\Activate.ps1`

install:\
`pip install -r requirements.txt`

run:\
`uvicorn app.main:app --reload`

Expected local address:\
`http://127.0.0.1:8000`

swagger:\
`http://127.0.0.1:8000/docs`

adminer:\
`http://127.0.0.1:8080`

keycloak:\
`http://127.0.0.1:8081`

keycloak admin console:\
`http://127.0.0.1:8081/admin` (admin / admin)

Mailpit <- fake SMTP server: \
`http://localhost:8025`

filter examples:\
```
/events/filter?kind=cave
/events/filter?min_length=1000
/events/filter?kind=cave&region=Slovakia&min_length=1000
/events/filter?protected=true&max_length=2000
```

## Sensor data (TimescaleDB)

Seed 30 days of fake readings for all sensors:
```bash
python seed_sensors.py
```

Options:
```bash
python seed_sensors.py --days 7           # fewer days
python seed_sensors.py --clear            # wipe existing readings first
python seed_sensors.py --live             # seed 24 h then stream live every 10 s
python seed_sensors.py --live --interval 3  # faster live updates for demo
```

Sensors seeded by `postgres-init/04-sensors.sql`:
- `SEN-DOMICA-01` — Domica main chamber
- `SEN-JASOV-01` — Jasovská lower corridor
- `SEN-HARMAN-01` — Harmanecká Izbica hall

