\connect cavesdb

CREATE EXTENSION IF NOT EXISTS timescaledb;
CREATE EXTENSION IF NOT EXISTS postgis;

-- ── Caves ─────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS caves (
    id                UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    name              TEXT        NOT NULL,
    cave_type         TEXT        NOT NULL,
    region            TEXT        NOT NULL,
    municipality      TEXT,
    geom              geometry(Point, 4326) NOT NULL,
    length_m          NUMERIC,
    depth_m           NUMERIC,
    is_public         BOOLEAN     NOT NULL DEFAULT false,
    sensitivity_level TEXT        NOT NULL DEFAULT 'restricted',
    payload           JSONB       NOT NULL DEFAULT '{}',
    created_at        TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS caves_geom_gix ON caves USING GIST (geom);

-- ── Cave surveys ──────────────────────────────────────────────────────────────
-- Tiered knowledge records for a cave (public / caver / scientific tiers)
CREATE TABLE IF NOT EXISTS cave_surveys (
    id                 UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    cave_id            UUID        NOT NULL REFERENCES caves(id),
    name               TEXT        NOT NULL,
    public_payload     JSONB       NOT NULL DEFAULT '{}',
    caver_payload      JSONB       NOT NULL DEFAULT '{}',
    scientific_payload JSONB       NOT NULL DEFAULT '{}',
    created_at         TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ── Cave entrances ────────────────────────────────────────────────────────────
-- Individual entrance points; a single cave can have multiple entrances
CREATE TABLE IF NOT EXISTS cave_entrances (
    id            UUID    PRIMARY KEY DEFAULT gen_random_uuid(),
    cave_id       UUID    NOT NULL REFERENCES caves(id),
    name          TEXT,
    geom          geometry(Point, 4326) NOT NULL,
    entrance_type TEXT,
    is_public     BOOLEAN NOT NULL DEFAULT false
);

CREATE INDEX IF NOT EXISTS cave_entrances_geom_gix ON cave_entrances USING GIST (geom);

-- ── Cave survey lines ─────────────────────────────────────────────────────────
-- Mapped underground passages from topographic surveys
CREATE TABLE IF NOT EXISTS cave_survey_lines (
    id      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    cave_id UUID NOT NULL REFERENCES caves(id),
    geom    geometry(LineString, 4326) NOT NULL,
    payload JSONB NOT NULL DEFAULT '{}'
);

CREATE INDEX IF NOT EXISTS cave_survey_lines_geom_gix ON cave_survey_lines USING GIST (geom);

-- ── Protected areas ───────────────────────────────────────────────────────────
-- Nature protection zones (national parks, nature reserves)
CREATE TABLE IF NOT EXISTS protected_areas (
    id      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name    TEXT  NOT NULL,
    geom    geometry(MultiPolygon, 4326) NOT NULL,
    payload JSONB NOT NULL DEFAULT '{}'
);

CREATE INDEX IF NOT EXISTS protected_areas_geom_gix ON protected_areas USING GIST (geom);

-- ── Views ─────────────────────────────────────────────────────────────────────
-- Public layer: only public caves, coordinates snapped to ~5 km grid
CREATE OR REPLACE VIEW caves_public AS
SELECT
    id, name, cave_type, region, municipality,
    ST_SnapToGrid(geom, 0.05) AS geom,
    length_m, depth_m, sensitivity_level, payload, created_at
FROM caves
WHERE is_public = true;

-- Restricted layer: all caves, exact coordinates
CREATE OR REPLACE VIEW caves_restricted AS
SELECT
    id, name, cave_type, region, municipality,
    geom,
    length_m, depth_m, is_public, sensitivity_level, payload, created_at
FROM caves;
