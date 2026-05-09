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
  ST_GeomFromGeoJSON('{"type":"MultiPolygon","coordinates":[[[[20.1899971,48.5876678],[20.1810579,48.6027339],[20.1970858,48.6197976],[20.217341,48.6274901],[20.2674661,48.6291116],[20.2942518,48.6189577],[20.3454838,48.6152402],[20.3798076,48.5999433],[20.3888224,48.6112886],[20.3889425,48.6588107],[20.397745,48.6640944],[20.4251745,48.6652029],[20.4786837,48.6485805],[20.4839694,48.6393653],[20.4582144,48.6408958],[20.4550267,48.6351146],[20.4709635,48.610131],[20.4793486,48.6084481],[20.5217022,48.6275424],[20.5923161,48.6176362],[20.6207994,48.626042],[20.6234603,48.6365824],[20.6428104,48.6363191],[20.6428984,48.6421039],[20.6785376,48.6535031],[20.7033294,48.6356476],[20.7105592,48.6448757],[20.7564432,48.647105],[20.7570851,48.6592435],[20.7966373,48.6616748],[20.8291147,48.6754993],[20.8375412,48.6747184],[20.8465706,48.6597518],[20.8666769,48.6570383],[20.9529442,48.6743866],[20.935239,48.6448886],[20.9649606,48.6297091],[20.9167231,48.6186426],[20.8501199,48.6337696],[20.8813736,48.6084704],[20.8368326,48.5751163],[20.836359,48.58284],[20.728106,48.56448],[20.713132,48.570391],[20.679502,48.559516],[20.653874,48.561413],[20.644056,48.551977],[20.586595,48.535759],[20.546494,48.544292],[20.537471,48.527878],[20.5191,48.537519],[20.506507,48.534415],[20.5079887,48.4893987],[20.4950662,48.4876677],[20.4855325,48.4738744],[20.4548581,48.4825997],[20.4265235,48.5071169],[20.4153373,48.5245441],[20.4386181,48.5378322],[20.399501,48.5497074],[20.3741748,48.5357478],[20.3651106,48.5386298],[20.371605,48.5489248],[20.3532637,48.5630805],[20.3400216,48.5548114],[20.3166967,48.558007],[20.3005763,48.551615],[20.3024702,48.5672157],[20.3479194,48.5807049],[20.3463848,48.5907559],[20.2807581,48.6112637],[20.2730155,48.5843556],[20.1899971,48.5876678]]]]}'),
  '{"category": "National Park", "area_km2": 346, "established": 1973, "unesco_geopark": true, "country": "SK", "caves_count": 1100}'
),
(
  'Národný park Nízke Tatry',
  ST_GeomFromGeoJSON('{"type":"MultiPolygon","coordinates":[[[[19.2617718,48.9155161],[19.2614965,48.9551668],[19.2910718,48.9974121],[19.2979323,49.0396908],[19.3107725,49.0487176],[19.3418355,49.0366134],[19.3906624,49.0406371],[19.4143237,49.0503884],[19.5171928,49.0189305],[19.5722597,49.0259557],[19.608127,49.0519503],[19.6496668,49.0484336],[19.6744089,49.0336744],[19.6825053,49.0470732],[19.7334888,49.0259901],[19.7708819,49.0242616],[19.8009745,49.0085577],[20.0341913,49.0172853],[20.0736656,49.0012776],[20.0946556,48.9811036],[20.1140581,48.9880241],[20.1383479,48.9762445],[20.2515101,48.985076],[20.30004,48.9773484],[20.2950782,48.9518265],[20.2822064,48.9361357],[20.1941974,48.891868],[20.1896277,48.8583586],[20.1344955,48.8420691],[20.0381158,48.8524808],[20.0146727,48.8767739],[19.9964655,48.8730374],[19.9830315,48.8812361],[19.9606618,48.8738339],[19.9083242,48.8766303],[19.8610767,48.8649565],[19.8050671,48.8657616],[19.7932902,48.8531211],[19.7627258,48.8563094],[19.744381,48.8485118],[19.6763385,48.8483355],[19.6193624,48.8748163],[19.5728872,48.8785026],[19.4857083,48.8649018],[19.4465161,48.8462536],[19.4351389,48.8281516],[19.4082912,48.8178156],[19.4049982,48.8245282],[19.3800833,48.8232843],[19.3752211,48.8351649],[19.2719685,48.8718566],[19.2617718,48.9155161]]]]}'),
  '{"category": "National Park", "area_km2": 728, "established": 1978, "highest_peak": "Ďumbier 2046m", "country": "SK"}'
);
