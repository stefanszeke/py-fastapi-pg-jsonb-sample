\connect cavesdb

CREATE TABLE IF NOT EXISTS events (
    id               SERIAL PRIMARY KEY,
    name             VARCHAR(100) NOT NULL,
    public_payload   JSONB        NOT NULL,
    caver_payload    JSONB        NOT NULL DEFAULT '{}',
    scientific_payload JSONB      NOT NULL DEFAULT '{}'
);
