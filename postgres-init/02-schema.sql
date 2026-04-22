\connect cavesdb

CREATE TABLE IF NOT EXISTS caves (
    id        SERIAL PRIMARY KEY,
    name      VARCHAR(150) NOT NULL,
    lon       NUMERIC(9,6) NOT NULL,
    lat       NUMERIC(9,6) NOT NULL,
    type      VARCHAR(80)  NOT NULL,
    depth_m   INTEGER,
    region    VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS events (
    id                 SERIAL PRIMARY KEY,
    cave_id            INTEGER      NOT NULL REFERENCES caves(id),
    name               VARCHAR(100) NOT NULL,
    public_payload     JSONB        NOT NULL,
    caver_payload      JSONB        NOT NULL DEFAULT '{}',
    scientific_payload JSONB        NOT NULL DEFAULT '{}'
);
