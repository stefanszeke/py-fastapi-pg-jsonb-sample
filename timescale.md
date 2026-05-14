# TimescaleDB — Caves SK

TimescaleDB is a PostgreSQL extension for time-series data.
The `timescale/timescaledb-ha` Docker image includes both TimescaleDB and PostGIS.

---

## Tables and views

### `sensors` — device registry (plain PostgreSQL)

```sql
id            UUID  PRIMARY KEY
cave_id       UUID  → caves.id
sensor_code   TEXT  UNIQUE        -- e.g. SEN-DOMICA-01
name          TEXT
description   TEXT
installed_at  DATE
```

Normal relational table. Maps a physical sensor to a cave.

---

### `cave_sensor_readings` — hypertable

```sql
measured_at  TIMESTAMPTZ   -- partition key
sensor_id    UUID          → sensors.id
temperature  DOUBLE PRECISION
humidity     DOUBLE PRECISION
co2          INTEGER
```

Looks like a normal table but TimescaleDB partitions it internally into **time chunks** (default 7 days each).
Queries scoped to a time range only scan the relevant chunk — not the whole table.

Created with:
```sql
SELECT create_hypertable('cave_sensor_readings', 'measured_at');
```

At 10-minute intervals across 3 sensors → ~130 000 rows/month. Scales to years without slowing down.

---

### `sensor_readings_hourly` — continuous aggregate

```sql
hour          TIMESTAMPTZ   -- truncated to 1 h
sensor_id     UUID
avg_temp      NUMERIC(5,2)
min_temp      NUMERIC(5,2)
max_temp      NUMERIC(5,2)
avg_humidity  NUMERIC(5,1)
avg_co2       INTEGER
reading_count BIGINT
```

Pre-computed hourly rollup of the raw readings.
TimescaleDB refreshes it automatically in the background as new data arrives.

Refresh policy: every hour, covering data up to 3 days back.

---

## Data flow

```
sensors  (1)
  └── cave_sensor_readings     raw readings, every 10 min, hypertable
            └── sensor_readings_hourly   auto rollup, 1 row per sensor per hour
```

## When to query which

| Use case                  | Query                      |
|---------------------------|----------------------------|
| Last 24 h detail chart    | `cave_sensor_readings`     |
| Last 7 / 30 day trend     | `sensor_readings_hourly`   |
| Sensor list               | `sensors`                  |

---

## Useful queries

Last 24 hours for one sensor:
```sql
SELECT measured_at, temperature, humidity, co2
FROM cave_sensor_readings
WHERE sensor_id = '<uuid>'
  AND measured_at > now() - interval '24 hours'
ORDER BY measured_at;
```

Hourly averages for the last 7 days:
```sql
SELECT hour, avg_temp, avg_humidity, avg_co2
FROM sensor_readings_hourly
WHERE sensor_id = '<uuid>'
  AND hour > now() - interval '7 days'
ORDER BY hour;
```

All sensors for a cave:
```sql
SELECT s.sensor_code, s.name, s.installed_at
FROM sensors s
JOIN caves c ON c.id = s.cave_id
WHERE c.name = 'Domica';
```

Check chunk info:
```sql
SELECT * FROM timescaledb_information.chunks
WHERE hypertable_name = 'cave_sensor_readings';
```

---

## Seeded sensors

| Code            | Cave               | Location                     |
|-----------------|--------------------|------------------------------|
| SEN-DOMICA-01   | Domica             | Main dripstone hall          |
| SEN-JASOV-01    | Jasovská jaskyňa   | Lower tourist corridor       |
| SEN-HARMAN-01   | Harmanecká jaskyňa | Izbica entrance chamber      |

Fake data generator: see `seed_sensors.py` and `readme.md`.
