# PostGIS Guide

## What is PostGIS?

PostgreSQL stores numbers, text, JSON. PostGIS is an **extension** that adds a new column type — `geometry` — and hundreds of functions that understand geographic space.

```sql
CREATE EXTENSION IF NOT EXISTS postgis;  -- already in 02-schema.sql
```

---

## Geometry columns in this project

```sql
geom geometry(Point, 4326)
```

- `Point` — the shape type
- `4326` — the coordinate system (WGS84, the same lat/lon GPS uses)

| Table | Type | What it stores |
|---|---|---|
| `caves` | `Point` | Cave location |
| `cave_entrances` | `Point` | A single entrance location |
| `cave_survey_lines` | `LineString` | A path through the cave |
| `protected_areas` | `MultiPolygon` | One or more polygon boundaries |

---

## Inserting geometry

Use constructor functions instead of plain values:

```sql
-- Point from lon, lat
ST_SetSRID(ST_MakePoint(19.991, 49.042), 4326)

-- Line from text
ST_SetSRID(ST_GeomFromText('LINESTRING(19.99 49.04, 19.99 49.05)'), 4326)

-- From GeoJSON string
ST_GeomFromGeoJSON('{"type":"Point","coordinates":[19.991,49.042]}')
```

---

## Reading geometry back

Raw geometry is binary — useless to display. Convert it with functions:

```sql
-- Extract coordinates from a Point
ST_X(geom)   -- longitude
ST_Y(geom)   -- latitude

-- Convert any geometry to a GeoJSON string
ST_AsGeoJSON(geom)
-- → '{"type":"LineString","coordinates":[[19.99,49.04],[19.99,49.05]]}'

-- Convert to WKT (human-readable text)
ST_AsText(geom)
-- → 'POINT(19.991 49.042)'
```

This is what the routers do — `ST_X`/`ST_Y` for cave/entrance points, `ST_AsGeoJSON` for lines and polygons (which OpenLayers parses directly on the frontend).

---

## Spatial operations

Functions that answer geographic questions:

```sql
-- Distance between two points (degrees)
ST_Distance(a.geom, b.geom)

-- Is this point inside this polygon?
ST_Within(cave.geom, protected_area.geom)

-- Do these geometries overlap?
ST_Intersects(a.geom, b.geom)

-- Caves within 10km of a point (real metres using geography cast)
ST_DWithin(
    geom::geography,
    ST_MakePoint(19.99, 49.04)::geography,
    10000
)

-- Simplify a polygon (fewer points, same rough shape)
ST_Simplify(geom, 0.005)

-- Snap coordinates to a grid (used for role-based precision)
ST_SnapToGrid(geom, 0.05)
```

---

## Spatial indexes

Normal indexes do not work on geometry. PostGIS uses **GIST** indexes:

```sql
CREATE INDEX caves_geom_gix ON caves USING GIST (geom);
```

Without this, spatial queries scan every row. With it, PostgreSQL uses a bounding-box tree to skip most rows instantly. All 4 geometry tables in this project have GIST indexes.

---

## How this project uses PostGIS end-to-end

```
Browser clicks map
  → Vue calls authFetch('/caves')
    → FastAPI router runs SQL with ST_X / ST_Y / ST_SnapToGrid
      → PostgreSQL+PostGIS returns lon/lat numbers
        → Vue plots Point(fromLonLat([lon, lat])) on OpenLayers map

Browser clicks a cave
  → authFetch('/survey-lines/by-cave/{id}')
    → SQL runs ST_AsGeoJSON(geom)
      → Returns '{"type":"LineString","coordinates":[...]}'
        → Vue passes it to geojsonFormat.readFeatures(geom)
          → OpenLayers draws the line on the map
```

---

## Role-based geometry precision

Visitors get approximate coordinates to protect sensitive cave locations:

```python
# app/routers/caves.py
exact = auth.has_any("caves:read_restricted")

lon_col = ST_X(Cave.geom) if exact else ST_X(ST_SnapToGrid(Cave.geom, 0.05))
lat_col = ST_Y(Cave.geom) if exact else ST_Y(ST_SnapToGrid(Cave.geom, 0.05))
```

`ST_SnapToGrid(geom, 0.05)` rounds coordinates to the nearest 0.05° (~4km grid), enough to show the general area without revealing the exact entrance.

---

## Fetching real boundary data from OSM

Boundary polygons for protected areas were downloaded from OpenStreetMap.

**Search by name (Nominatim):**
```
https://nominatim.openstreetmap.org/search?q=Slovenský+kras&format=geojson&polygon_geojson=1&countrycodes=sk&limit=3
```

| Parameter | Meaning |
|---|---|
| `q` | Place name to search |
| `format=geojson` | Return GeoJSON |
| `polygon_geojson=1` | Include the full boundary polygon |
| `countrycodes=sk` | Limit to Slovakia |

**Fetch by OSM relation ID (more reliable):**
```
https://polygons.openstreetmap.fr/get_geojson.py?id=1934524&params=0
```

The relation ID can be found by clicking any area on [openstreetmap.org](https://www.openstreetmap.org) and reading the number from the URL.

---

## What to add next

**Proximity search** — find caves within 20km of a clicked point:

```sql
SELECT id, name,
       ST_Distance(geom::geography, ST_MakePoint(:lon, :lat)::geography) AS distance_m
FROM caves
WHERE ST_DWithin(
    geom::geography,
    ST_MakePoint(:lon, :lat)::geography,
    20000
)
ORDER BY distance_m;
```

The `::geography` cast makes distances use real metres on the Earth's surface instead of degrees.

**Spatial join** — find which protected area each cave falls in:

```sql
SELECT c.name AS cave, p.name AS protected_area
FROM caves c
JOIN protected_areas p ON ST_Within(c.geom, p.geom);
```
