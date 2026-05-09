\connect cavesdb

-- ── Caves ─────────────────────────────────────────────────────────────────────
INSERT INTO caves (id, name, cave_type, region, municipality, geom, length_m, depth_m, is_public, sensitivity_level, payload) VALUES
(
  'a0000001-0000-0000-0000-000000000001',
  'Domica',
  'Karst cave',
  'Slovak Karst',
  'Dlhá Ves',
  ST_SetSRID(ST_MakePoint(20.463, 48.359), 4326),
  5358, 25, true, 'public',
  '{"unesco": true, "show_cave": true, "hydrology": "active_stream"}'
),
(
  'a0000001-0000-0000-0000-000000000002',
  'Jasovská jaskyňa',
  'Limestone cave',
  'Košice',
  'Jasov',
  ST_SetSRID(ST_MakePoint(20.906, 48.631), 4326),
  2811, 22, true, 'public',
  '{"show_cave": true, "monastery_nearby": true}'
),
(
  'a0000001-0000-0000-0000-000000000003',
  'Važecká jaskyňa',
  'Crystalline limestone cave',
  'Liptov',
  'Važec',
  ST_SetSRID(ST_MakePoint(19.991, 49.042), 4326),
  850, 30, true, 'public',
  '{"show_cave": true, "paleontology": true}'
),
(
  'a0000001-0000-0000-0000-000000000004',
  'Silická Ľadnica',
  'Ice cave',
  'Slovak Karst',
  'Silica',
  ST_SetSRID(ST_MakePoint(20.536, 48.554), 4326),
  1107, 45, false, 'highly_restricted',
  '{"permafrost": true, "ice_volume_m3": 12000, "access": "permit_required"}'
),
(
  'a0000001-0000-0000-0000-000000000005',
  'Harmanecká jaskyňa',
  'Limestone cave',
  'Banská Bystrica',
  'Harmanec',
  ST_SetSRID(ST_MakePoint(19.064, 48.847), 4326),
  2900, 35, true, 'restricted',
  '{"show_cave": true, "bat_sanctuary": true}'
);

-- ── Cave surveys ──────────────────────────────────────────────────────────────
INSERT INTO cave_surveys (cave_id, name, public_payload, caver_payload, scientific_payload) VALUES
(
  'a0000001-0000-0000-0000-000000000001',
  'Domica Survey 2023',
  '{"kind": "karst", "tags": ["karst", "UNESCO", "tourism", "active_stream"], "protected": true, "region": "Slovak Karst"}',
  '{"length_m": 5358, "difficulty": "easy", "equipment_required": ["lamp"], "notable_features": ["underground river", "stalactites", "boat tour"]}',
  '{"geology": "triassic limestone", "discovered": 1926, "species_count": 34, "drainage_basin": "Styx river", "bat_colonies": 5, "avg_temp_c": 12}'
),
(
  'a0000001-0000-0000-0000-000000000002',
  'Jasovská Survey 2022',
  '{"kind": "karst", "tags": ["karst", "tourism", "historical"], "protected": true, "region": "Košice"}',
  '{"length_m": 2811, "difficulty": "easy", "equipment_required": ["lamp", "jacket"], "notable_features": ["dripstones", "historical graffiti"]}',
  '{"geology": "triassic limestone", "discovered": 1846, "species_count": 21, "bat_colonies": 3, "avg_temp_c": 9}'
),
(
  'a0000001-0000-0000-0000-000000000003',
  'Važecká Survey 2023',
  '{"kind": "karst", "tags": ["karst", "paleontology"], "protected": true, "region": "Liptov"}',
  '{"length_m": 850, "difficulty": "medium", "equipment_required": ["helmet", "lamp", "jacket"], "notable_features": ["cave bear fossils", "mammoth remains"]}',
  '{"geology": "crystalline limestone", "discovered": 1922, "species_count": 8, "fossil_finds": ["cave bear", "mammoth"], "avg_temp_c": 7}'
),
(
  'a0000001-0000-0000-0000-000000000004',
  'Silická Ľadnica Survey 2021',
  '{"kind": "ice_cave", "tags": ["ice", "karst", "rare", "restricted"], "protected": true, "region": "Slovak Karst"}',
  '{"length_m": 1107, "difficulty": "hard", "equipment_required": ["helmet", "lamp", "crampons", "rope"], "notable_features": ["permanent ice", "ice columns", "frost flowers"]}',
  '{"geology": "limestone with permafrost", "discovered": 1931, "species_count": 5, "avg_temp_c": -4, "ice_volume_m3": 12000, "climate_monitoring": true}'
),
(
  'a0000001-0000-0000-0000-000000000005',
  'Harmanecká Survey 2023',
  '{"kind": "karst", "tags": ["karst", "bats", "tourism"], "protected": false, "region": "Banská Bystrica"}',
  '{"length_m": 2900, "difficulty": "medium", "equipment_required": ["helmet", "lamp"], "notable_features": ["bat colonies", "aragonite", "dripstones"]}',
  '{"geology": "mesozoic limestone", "discovered": 1932, "species_count": 18, "bat_colonies": 7, "drip_rate_ml_hr": 450, "avg_temp_c": 8}'
);

-- ── Cave entrances ────────────────────────────────────────────────────────────
INSERT INTO cave_entrances (cave_id, name, geom, entrance_type, is_public) VALUES
-- Domica
('a0000001-0000-0000-0000-000000000001', 'Main entrance',     ST_SetSRID(ST_MakePoint(20.4628, 48.3592), 4326), 'tourist',   true),
('a0000001-0000-0000-0000-000000000001', 'Baradla connection',ST_SetSRID(ST_MakePoint(20.4715, 48.3541), 4326), 'technical', false),
-- Jasovská
('a0000001-0000-0000-0000-000000000002', 'Main entrance',     ST_SetSRID(ST_MakePoint(20.9058, 48.6312), 4326), 'tourist',   true),
-- Važecká
('a0000001-0000-0000-0000-000000000003', 'Main entrance',     ST_SetSRID(ST_MakePoint(19.9912, 49.0418), 4326), 'tourist',   true),
-- Silická Ľadnica
('a0000001-0000-0000-0000-000000000004', 'Main shaft',        ST_SetSRID(ST_MakePoint(20.5362, 48.5538), 4326), 'vertical',  false),
-- Harmanecká
('a0000001-0000-0000-0000-000000000005', 'Main entrance',     ST_SetSRID(ST_MakePoint(19.0638, 48.8472), 4326), 'tourist',   true),
('a0000001-0000-0000-0000-000000000005', 'Emergency exit',    ST_SetSRID(ST_MakePoint(19.0701, 48.8498), 4326), 'emergency', false);

-- ── Cave survey lines ─────────────────────────────────────────────────────────
INSERT INTO cave_survey_lines (cave_id, geom, payload) VALUES
(
  'a0000001-0000-0000-0000-000000000001',
  ST_SetSRID(ST_GeomFromText('LINESTRING(20.4628 48.3592, 20.4651 48.3601, 20.4688 48.3589, 20.4715 48.3571, 20.4741 48.3558)'), 4326),
  '{"passage_name": "Main gallery", "surveyed_by": "SSS Rožňava", "year": 2023, "avg_width_m": 8, "avg_height_m": 6}'
),
(
  'a0000001-0000-0000-0000-000000000002',
  ST_SetSRID(ST_GeomFromText('LINESTRING(20.9058 48.6312, 20.9078 48.6325, 20.9101 48.6318, 20.9122 48.6305)'), 4326),
  '{"passage_name": "Lower corridor", "surveyed_by": "SSS Košice", "year": 2022, "avg_width_m": 5, "avg_height_m": 4}'
),
(
  'a0000001-0000-0000-0000-000000000003',
  ST_SetSRID(ST_GeomFromText('LINESTRING(19.9912 49.0418, 19.9935 49.0428, 19.9958 49.0421, 19.9978 49.0411)'), 4326),
  '{"passage_name": "Fossil hall", "surveyed_by": "SSS Liptov", "year": 2023, "avg_width_m": 3, "avg_height_m": 4}'
),
(
  'a0000001-0000-0000-0000-000000000004',
  ST_SetSRID(ST_GeomFromText('LINESTRING(20.5362 48.5538, 20.5371 48.5528, 20.5385 48.5521)'), 4326),
  '{"passage_name": "Ice chamber", "surveyed_by": "SSS Rožňava", "year": 2021, "avg_width_m": 12, "avg_height_m": 15}'
),
(
  'a0000001-0000-0000-0000-000000000005',
  ST_SetSRID(ST_GeomFromText('LINESTRING(19.0638 48.8472, 19.0661 48.8485, 19.0689 48.8491, 19.0712 48.8481)'), 4326),
  '{"passage_name": "Main passage", "surveyed_by": "SSS Banská Bystrica", "year": 2023, "avg_width_m": 4, "avg_height_m": 5}'
);

-- ── Protected areas ───────────────────────────────────────────────────────────
INSERT INTO protected_areas (name, geom, payload) VALUES
(
  'Slovenský kras',
  ST_SetSRID(ST_GeomFromText('MULTIPOLYGON(((20.25 48.40, 21.05 48.40, 21.05 48.72, 20.25 48.72, 20.25 48.40)))'), 4326),
  '{"category": "National Park", "area_km2": 346, "established": 1973, "unesco_geopark": true, "country": "SK", "caves_count": 1100}'
),
(
  'Národný park Nízke Tatry',
  ST_SetSRID(ST_GeomFromText('MULTIPOLYGON(((18.50 48.70, 20.20 48.70, 20.20 49.15, 18.50 49.15, 18.50 48.70)))'), 4326),
  '{"category": "National Park", "area_km2": 728, "established": 1978, "highest_peak": "Ďumbier 2046m", "country": "SK"}'
);
