\connect cavesdb

-- ── Sensor registry ───────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS sensors (
    id            UUID  PRIMARY KEY DEFAULT gen_random_uuid(),
    cave_id       UUID  NOT NULL REFERENCES caves(id),
    sensor_code   TEXT  NOT NULL UNIQUE,
    name          TEXT  NOT NULL,
    description   TEXT,
    installed_at  DATE
);

-- ── Raw readings (hypertable) ─────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS cave_sensor_readings (
    measured_at  TIMESTAMPTZ      NOT NULL,
    sensor_id    UUID             NOT NULL REFERENCES sensors(id),
    temperature  DOUBLE PRECISION,
    humidity     DOUBLE PRECISION,
    co2          INTEGER
);

SELECT create_hypertable('cave_sensor_readings', 'measured_at');

CREATE INDEX ON cave_sensor_readings (sensor_id, measured_at DESC);

-- ── Continuous aggregate: hourly rollup ───────────────────────────────────────
CREATE MATERIALIZED VIEW sensor_readings_hourly
WITH (timescaledb.continuous) AS
SELECT
    time_bucket('1 hour', measured_at)  AS hour,
    sensor_id,
    AVG(temperature)::NUMERIC(5,2)      AS avg_temp,
    MIN(temperature)::NUMERIC(5,2)      AS min_temp,
    MAX(temperature)::NUMERIC(5,2)      AS max_temp,
    AVG(humidity)::NUMERIC(5,1)         AS avg_humidity,
    AVG(co2)::INTEGER                   AS avg_co2,
    COUNT(*)                            AS reading_count
FROM cave_sensor_readings
GROUP BY hour, sensor_id;

SELECT add_continuous_aggregate_policy('sensor_readings_hourly',
    start_offset => INTERVAL '3 days',
    end_offset   => INTERVAL '1 hour',
    schedule_interval => INTERVAL '1 hour'
);

-- ── Seed sensors for existing caves ──────────────────────────────────────────
INSERT INTO sensors (cave_id, sensor_code, name, description, installed_at) VALUES
    (
        (SELECT id FROM caves WHERE name = 'Domica'),
        'SEN-DOMICA-01',
        'Domica Main Chamber',
        'Near the tourist path at the main dripstone hall',
        '2023-04-15'
    ),
    (
        (SELECT id FROM caves WHERE name = 'Jasovská jaskyňa'),
        'SEN-JASOV-01',
        'Jasovská Lower Corridor',
        'Mounted at the entrance to the lower tourist corridor',
        '2023-06-01'
    ),
    (
        (SELECT id FROM caves WHERE name = 'Harmanecká jaskyňa'),
        'SEN-HARMAN-01',
        'Harmanecká Izbica Hall',
        'Sensor near the Izbica entrance chamber',
        '2024-02-10'
    );
