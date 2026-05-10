\connect cavesdb

-- ── Caves ─────────────────────────────────────────────────────────────────────
-- Coordinates: OSM entrance nodes confirmed by SSJ (Slovak Caves Administration)
-- Dimensions:  Official SSJ figures
INSERT INTO caves (id, name, cave_type, region, municipality, geom, length_m, depth_m, is_public, sensitivity_level, payload) VALUES
(
  'a0000001-0000-0000-0000-000000000001',
  'Domica',
  'Karst cave',
  'Slovak Karst',
  'Kečovo',
  ST_SetSRID(ST_MakePoint(20.469815, 48.477758), 4326),
  5368, 70, true, 'public',
  '{"unesco": true, "show_cave": true, "hydrology": "active_stream", "connected_to": "Baradla (Hungary)"}'
),
(
  'a0000001-0000-0000-0000-000000000002',
  'Jasovská jaskyňa',
  'Limestone cave',
  'Košice',
  'Jasov',
  ST_SetSRID(ST_MakePoint(20.976905, 48.677181), 4326),
  2811, 55, true, 'public',
  '{"show_cave": true, "monastery_nearby": true, "levels": 5}'
),
(
  'a0000001-0000-0000-0000-000000000003',
  'Važecká jaskyňa',
  'Crystalline limestone cave',
  'Liptov',
  'Važec',
  ST_SetSRID(ST_MakePoint(19.971821, 49.056317), 4326),
  530, 5, true, 'public',
  '{"show_cave": true, "paleontology": true, "elevation_m": 784}'
),
(
  'a0000001-0000-0000-0000-000000000004',
  'Silická ľadnica',
  'Ice cave',
  'Slovak Karst',
  'Silica',
  ST_SetSRID(ST_MakePoint(20.503557, 48.549498), 4326),
  1100, 110, false, 'highly_restricted',
  '{"permafrost": true, "ice_volume_m3": 12000, "access": "permit_required", "shaft_depth_m": 90, "elevation_m": 503}'
),
(
  'a0000001-0000-0000-0000-000000000005',
  'Harmanecká jaskyňa',
  'Limestone cave',
  'Banská Bystrica',
  'Harmanec',
  ST_SetSRID(ST_MakePoint(19.040013, 48.813839), 4326),
  3123, 75, true, 'restricted',
  '{"show_cave": true, "bat_sanctuary": true, "elevation_m": 821}'
);

-- ── Cave surveys ──────────────────────────────────────────────────────────────
INSERT INTO cave_surveys (cave_id, name, public_payload, caver_payload, scientific_payload) VALUES
(
  'a0000001-0000-0000-0000-000000000001',
  'Domica Survey 2023',
  '{"kind": "karst", "tags": ["karst", "UNESCO", "tourism", "active_stream"], "protected": true, "region": "Slovak Karst"}',
  '{"length_m": 5368, "difficulty": "easy", "equipment_required": ["lamp"], "notable_features": ["underground river Styx", "stalactites", "boat tour", "Baradla connection"]}',
  '{"geology": "triassic limestone", "discovered": 1926, "species_count": 34, "drainage_basin": "Styx river", "bat_colonies": 5, "avg_temp_c": 12}'
),
(
  'a0000001-0000-0000-0000-000000000002',
  'Jasovská Survey 2022',
  '{"kind": "karst", "tags": ["karst", "tourism", "historical"], "protected": true, "region": "Košice"}',
  '{"length_m": 2811, "difficulty": "easy", "equipment_required": ["lamp", "jacket"], "notable_features": ["5 levels", "dripstones", "historical graffiti"]}',
  '{"geology": "triassic limestone", "discovered": 1846, "species_count": 21, "bat_colonies": 3, "avg_temp_c": 9}'
),
(
  'a0000001-0000-0000-0000-000000000003',
  'Važecká Survey 2023',
  '{"kind": "karst", "tags": ["karst", "paleontology"], "protected": true, "region": "Liptov"}',
  '{"length_m": 530, "difficulty": "medium", "equipment_required": ["helmet", "lamp", "jacket"], "notable_features": ["cave bear fossils", "mammoth remains"]}',
  '{"geology": "crystalline limestone", "discovered": 1922, "species_count": 8, "fossil_finds": ["cave bear", "mammoth"], "avg_temp_c": 7}'
),
(
  'a0000001-0000-0000-0000-000000000004',
  'Silická ľadnica Survey 2021',
  '{"kind": "ice_cave", "tags": ["ice", "karst", "rare", "restricted"], "protected": true, "region": "Slovak Karst"}',
  '{"length_m": 1100, "difficulty": "hard", "equipment_required": ["helmet", "lamp", "crampons", "rope", "vertical_gear"], "notable_features": ["90 m entrance shaft", "permanent ice", "ice columns", "frost flowers"]}',
  '{"geology": "limestone with permafrost", "discovered": 1931, "species_count": 5, "avg_temp_c": -4, "ice_volume_m3": 12000, "climate_monitoring": true}'
),
(
  'a0000001-0000-0000-0000-000000000005',
  'Harmanecká Survey 2023',
  '{"kind": "karst", "tags": ["karst", "bats", "tourism"], "protected": false, "region": "Banská Bystrica"}',
  '{"length_m": 3123, "difficulty": "medium", "equipment_required": ["helmet", "lamp"], "notable_features": ["bat colonies", "aragonite", "Dome of Pagodas"]}',
  '{"geology": "mesozoic limestone", "discovered": 1932, "species_count": 18, "bat_colonies": 7, "drip_rate_ml_hr": 450, "avg_temp_c": 8}'
);

-- ── Cave entrances ────────────────────────────────────────────────────────────
-- Sources: OSM entrance nodes, SSJ, ISCA cave registry
INSERT INTO cave_entrances (cave_id, name, geom, entrance_type, is_public) VALUES
-- Domica — 3 Slovak-side entrances
('a0000001-0000-0000-0000-000000000001', 'Tourist entrance',  ST_SetSRID(ST_MakePoint(20.469815, 48.477758), 4326), 'tourist',   true),
('a0000001-0000-0000-0000-000000000001', 'Original entrance', ST_SetSRID(ST_MakePoint(20.462000, 48.477200), 4326), 'technical', false),
('a0000001-0000-0000-0000-000000000001', 'Čertova diera',     ST_SetSRID(ST_MakePoint(20.439000, 48.475500), 4326), 'vertical',  false),
-- Jasovská — lower entry, upper exit
('a0000001-0000-0000-0000-000000000002', 'Lower entrance',    ST_SetSRID(ST_MakePoint(20.976905, 48.677181), 4326), 'tourist',   true),
('a0000001-0000-0000-0000-000000000002', 'Upper exit',        ST_SetSRID(ST_MakePoint(20.973000, 48.679500), 4326), 'tourist',   true),
-- Važecká — single entrance
('a0000001-0000-0000-0000-000000000003', 'Main entrance',     ST_SetSRID(ST_MakePoint(19.971821, 49.056317), 4326), 'tourist',   true),
-- Silická ľadnica — vertical sinkhole, interior closed to public
('a0000001-0000-0000-0000-000000000004', 'Sinkhole shaft',    ST_SetSRID(ST_MakePoint(20.503557, 48.549498), 4326), 'vertical',  false),
-- Harmanecká — single entrance
('a0000001-0000-0000-0000-000000000005', 'Izbica entrance',   ST_SetSRID(ST_MakePoint(19.040013, 48.813839), 4326), 'tourist',   true);

-- ── Cave survey lines ─────────────────────────────────────────────────────────
-- Passage directions from SSJ descriptions and geographic context.
-- Lines are schematic (no published open-source survey centrelines exist).
INSERT INTO cave_survey_lines (cave_id, geom, payload) VALUES
(
  -- Domica: runs WSW from tourist entrance following underground Styx river toward Hungary
  'a0000001-0000-0000-0000-000000000001',
  ST_SetSRID(ST_GeomFromText('LINESTRING(20.4698 48.4778, 20.4620 48.4772, 20.4540 48.4765, 20.4460 48.4760, 20.4390 48.4755)'), 4326),
  '{"passage_name": "Styx gallery", "surveyed_by": "SSS Rožňava", "year": 2023, "avg_width_m": 8, "avg_height_m": 6}'
),
(
  -- Jasovská: ascending N–NW through Jasovská skala massif, lower entry to upper exit
  'a0000001-0000-0000-0000-000000000002',
  ST_SetSRID(ST_GeomFromText('LINESTRING(20.9769 48.6772, 20.9760 48.6778, 20.9748 48.6785, 20.9737 48.6791, 20.9730 48.6795)'), 4326),
  '{"passage_name": "Main corridor", "surveyed_by": "SSS Košice", "year": 2022, "avg_width_m": 5, "avg_height_m": 4}'
),
(
  -- Važecká: runs SW from entrance per showcaves.com NE–SW passage description
  'a0000001-0000-0000-0000-000000000003',
  ST_SetSRID(ST_GeomFromText('LINESTRING(19.9718 49.0563, 19.9705 49.0558, 19.9692 49.0552, 19.9680 49.0547)'), 4326),
  '{"passage_name": "Fossil hall", "surveyed_by": "SSS Liptov", "year": 2023, "avg_width_m": 3, "avg_height_m": 4}'
),
(
  -- Silická ľadnica: near-vertical shaft then WSW horizontal ice chambers
  'a0000001-0000-0000-0000-000000000004',
  ST_SetSRID(ST_GeomFromText('LINESTRING(20.5036 48.5494, 20.5030 48.5490, 20.5020 48.5487, 20.5000 48.5478)'), 4326),
  '{"passage_name": "Ice chamber", "surveyed_by": "SSS Rožňava", "year": 2021, "avg_width_m": 12, "avg_height_m": 15}'
),
(
  -- Harmanecká: descends SSE into Kotolnica massif from N-facing entrance
  'a0000001-0000-0000-0000-000000000005',
  ST_SetSRID(ST_GeomFromText('LINESTRING(19.0401 48.8138, 19.0408 48.8130, 19.0415 48.8122, 19.0422 48.8115, 19.0430 48.8108)'), 4326),
  '{"passage_name": "Dome of Pagodas passage", "surveyed_by": "SSS Banská Bystrica", "year": 2023, "avg_width_m": 4, "avg_height_m": 5}'
);

-- ── Protected areas ───────────────────────────────────────────────────────────
-- Real boundary polygons from OpenStreetMap (relation IDs 1934524 and 1934502)
-- Simplified with Douglas-Peucker ε=0.005° (~400 m) via polygons.openstreetmap.fr
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

-- ── Additional real cave sample data ─────────────────────────────────────────
-- Sources: public SSJ / national-park / show-cave / wiki-style pages.
-- IMPORTANT: cave_survey_lines below are schematic demo lines, not official survey centerlines.
-- Public/show-cave coordinates are used only where already published publicly.

INSERT INTO caves (id, name, cave_type, region, municipality, geom, length_m, depth_m, is_public, sensitivity_level, payload) VALUES
(
  'a0000001-0000-0000-0000-000000000006',
  'Belianska jaskyňa',
  'Limestone cave',
  'Belianske Tatry',
  'Tatranská Lomnica',
  ST_SetSRID(ST_MakePoint(20.3115997, 49.2288017), 4326),
  3829, 168, true, 'public',
  '{"country": "SK", "elevation_m": 890, "geology": "limestone", "managed_by": "Slovak Caves Administration", "show_cave": true, "source_url": "https://www.ssj.sk/en/jaskyna/2-belianska-cave", "tags": ["show_cave", "Tatra National Park"]}'
),
(
  'a0000001-0000-0000-0000-000000000007',
  'Bystrianska jaskyňa',
  'Limestone cave',
  'Nízke Tatry',
  'Valaská',
  ST_SetSRID(ST_MakePoint(19.5949001, 48.8395004), 4326),
  3531, 99, true, 'public',
  '{"country": "SK", "elevation_m": 565, "geology": "limestone", "managed_by": "Slovak Caves Administration", "show_cave": true, "source_url": "https://www.ssj.sk/en/jaskyna/3-bystrianska-cave", "tags": ["show_cave", "Low Tatras"]}'
),
(
  'a0000001-0000-0000-0000-000000000008',
  'Demänovská jaskyňa slobody',
  'Limestone cave',
  'Nízke Tatry',
  'Demänovská Dolina',
  ST_SetSRID(ST_MakePoint(19.5851002, 48.9981003), 4326),
  11117, 130, true, 'public',
  '{"country": "SK", "elevation_m": 870, "geology": "limestone", "hydrology": "Demänovka", "managed_by": "Slovak Caves Administration", "ramsar": true, "show_cave": true, "source_url": "https://www.ssj.sk/en/jaskyna/4-demanovska-cave-of-liberty", "tags": ["show_cave", "Low Tatras", "Ramsar"]}'
),
(
  'a0000001-0000-0000-0000-000000000009',
  'Demänovská ľadová jaskyňa',
  'Ice limestone cave',
  'Nízke Tatry',
  'Demänovská Dolina',
  ST_SetSRID(ST_MakePoint(19.5827999, 49.016201), 4326),
  2445, 57, true, 'public',
  '{"country": "SK", "elevation_m": 840, "geology": "limestone", "ice_cave": true, "managed_by": "Slovak Caves Administration", "ramsar": true, "show_cave": true, "source_url": "https://www.ssj.sk/en/jaskyna/5-demanovska-ice-cave", "tags": ["show_cave", "ice", "Low Tatras", "Ramsar"]}'
),
(
  'a0000001-0000-0000-0000-000000000010',
  'Dobšinská ľadová jaskyňa',
  'Ice cave',
  'Slovenský raj',
  'Dobšiná',
  ST_SetSRID(ST_MakePoint(20.3024998, 48.868), 4326),
  1491, 75, true, 'public',
  '{"country": "SK", "elevation_m": 969, "geology": "limestone", "ice_cave": true, "managed_by": "Slovak Caves Administration", "show_cave": true, "source_url": "https://www.ssj.sk/en/jaskyna/6-dobsinska-ice-cave", "tags": ["show_cave", "ice", "UNESCO", "Slovak Paradise"], "unesco": true}'
),
(
  'a0000001-0000-0000-0000-000000000011',
  'Jaskyňa Driny',
  'Limestone cave',
  'Malé Karpaty',
  'Smolenice',
  ST_SetSRID(ST_MakePoint(17.4020996, 48.5004005), 4326),
  680, 40, true, 'public',
  '{"country": "SK", "geology": "limestone", "managed_by": "Slovak Caves Administration", "show_cave": true, "source_url": "https://www.ssj.sk/en/jaskyna/7-driny-cave", "tags": ["show_cave", "Little Carpathians"]}'
),
(
  'a0000001-0000-0000-0000-000000000012',
  'Gombasecká jaskyňa',
  'Limestone cave',
  'Slovak Karst',
  'Slavec',
  ST_SetSRID(ST_MakePoint(20.4664993, 48.5628014), 4326),
  3057, 68, true, 'public',
  '{"country": "SK", "geology": "limestone", "managed_by": "Slovak Caves Administration", "show_cave": true, "source_url": "https://www.ssj.sk/en/jaskyna/8-gombasecka-cave", "tags": ["show_cave", "UNESCO", "Slovak Karst", "straw stalactites"], "unesco": true}'
),
(
  'a0000001-0000-0000-0000-000000000013',
  'Ochtinská aragonitová jaskyňa',
  'Aragonite cave',
  'Slovenské rudohorie',
  'Ochtiná',
  ST_SetSRID(ST_MakePoint(20.3092003, 48.6646004), 4326),
  585, 30, true, 'public',
  '{"country": "SK", "geology": "crystalline limestone / aragonite", "managed_by": "Slovak Caves Administration", "show_cave": true, "source_url": "https://www.ssj.sk/en/jaskyna/9-ochtinska-aragonite-cave", "tags": ["show_cave", "UNESCO", "aragonite"], "unesco": true}'
),
(
  'a0000001-0000-0000-0000-000000000014',
  'Brestovská jaskyňa',
  'Limestone cave',
  'Západné Tatry',
  'Zuberec',
  ST_SetSRID(ST_MakePoint(19.6609001, 49.2588997), 4326),
  1890, 30, true, 'public',
  '{"country": "SK", "geology": "limestone", "hydrology": "active stream", "managed_by": "Slovak Caves Administration", "show_cave": true, "source_url": "https://www.ssj.sk/en/jaskyna/10-brestovska-cave", "tags": ["show_cave", "Western Tatras"]}'
),
(
  'a0000001-0000-0000-0000-000000000015',
  'Krásnohorská jaskyňa',
  'Limestone cave',
  'Slovak Karst',
  'Krásnohorská Dlhá Lúka',
  ST_SetSRID(ST_MakePoint(20.5875, 48.6180556), 4326),
  1355, NULL, true, 'restricted',
  '{"country": "SK", "geology": "limestone", "managed_by": "private guided access / Slovak Karst", "show_cave": true, "source_note": "GPS converted from public tourism coordinates N48°37''5'''' E20°35''15''''; SSJ article gives known length 1355 m but not a single total depth value.", "source_url": "https://www.ssj.sk/en/clanok/210-krasnohorska-cave", "tags": ["show_cave", "UNESCO", "guided adventure route"], "unesco": true}'
),
(
  'a0000001-0000-0000-0000-000000000016',
  'Baradla-barlang',
  'Karst cave',
  'Aggtelek Karst',
  'Aggtelek',
  ST_SetSRID(ST_MakePoint(20.495097, 48.471534), 4326),
  25500, 103, true, 'public',
  '{"connected_to": "Domica (Slovakia)", "country": "HU", "geology": "limestone", "managed_by": "Aggtelek National Park", "ramsar": true, "show_cave": true, "source_note": "Length stored as the commonly listed Baradla-Domica cross-border system figure; Hungarian Baradla-only length is often listed separately around 20.5 km.", "source_url": "https://www.i-s-c-a.org/show-cave/133-baradla-cave", "tags": ["show_cave", "UNESCO", "Aggtelek Karst", "Baradla-Domica system"], "unesco": true}'
),
(
  'a0000001-0000-0000-0000-000000000017',
  'Pál-völgyi-barlang',
  'Thermal karst cave',
  'Buda Hills',
  'Budapest',
  ST_SetSRID(ST_MakePoint(19.0162, 47.5329), 4326),
  32000, 104, true, 'public',
  '{"country": "HU", "geology": "limestone / thermal-water formed", "managed_by": "Duna-Ipoly National Park Directorate", "show_cave": true, "source_note": "Budapest tourism material lists about 32 km for the cave system; older ISCA data lists a shorter mapped extent.", "source_url": "https://www.dunaipoly.hu/en/places/interpretation-sites/pal-volgyi-cave", "tags": ["show_cave", "Budapest", "thermal karst"]}'
),
(
  'a0000001-0000-0000-0000-000000000018',
  'Szemlő-hegyi-barlang',
  'Thermal karst cave',
  'Buda Hills',
  'Budapest',
  ST_SetSRID(ST_MakePoint(19.0242, 47.5277), 4326),
  2200, NULL, true, 'public',
  '{"country": "HU", "geology": "limestone / thermal-water formed", "managed_by": "Duna-Ipoly National Park Directorate", "show_cave": true, "source_url": "https://www.dunaipoly.hu/en/places/interpretation-sites/szemlo-hegyi-cave", "tags": ["show_cave", "Budapest", "thermal karst"]}'
),
(
  'a0000001-0000-0000-0000-000000000019',
  'Tapolcai-tavasbarlang',
  'Lake cave',
  'Balaton Uplands',
  'Tapolca',
  ST_SetSRID(ST_MakePoint(17.443221, 46.883115), 4326),
  3300, 20, true, 'public',
  '{"country": "HU", "geology": "limestone / lake cave", "managed_by": "Balaton Uplands National Park Directorate", "show_cave": true, "source_note": "Depth represents the public description of passages about 15-20 m below the town.", "source_url": "https://www.bfnp.hu/en/oldal/about-the-lake-cave", "tags": ["show_cave", "lake cave", "boat tour", "Balaton Uplands"]}'
),
(
  'a0000001-0000-0000-0000-000000000020',
  'Abaligeti-barlang',
  'Karst cave',
  'Mecsek Mountains',
  'Abaliget',
  ST_SetSRID(ST_MakePoint(18.116235, 46.136679), 4326),
  1764, 10, true, 'public',
  '{"country": "HU", "geology": "limestone", "managed_by": "Duna-Dráva National Park Directorate", "show_cave": true, "source_url": "https://www.abaliget.hu/en/turisztika/abaliget-cave/", "tags": ["show_cave", "Mecsek", "stream cave"]}'
),
(
  'a0000001-0000-0000-0000-000000000021',
  'Anna-barlang',
  'Travertine cave',
  'Bükk Mountains',
  'Miskolc-Lillafüred',
  ST_SetSRID(ST_MakePoint(20.6248645782, 48.1050987244), 4326),
  570, NULL, true, 'public',
  '{"country": "HU", "geology": "travertine / limestone tufa", "managed_by": "Bükk National Park Directorate", "show_cave": true, "source_url": "https://www.miskolc.hu/en/life-city/tourism/sights/our-natural-resources/anna-cave", "tags": ["show_cave", "Bükk", "travertine"]}'
),
(
  'a0000001-0000-0000-0000-000000000022',
  'Szent István-barlang',
  'Dripstone cave',
  'Bükk Mountains',
  'Miskolc-Lillafüred',
  ST_SetSRID(ST_MakePoint(20.621374, 48.099893), 4326),
  1514, 101, true, 'public',
  '{"country": "HU", "geology": "Triassic limestone", "managed_by": "Bükk National Park Directorate", "show_cave": true, "source_note": "Depth field stores the published vertical dimension.", "source_url": "https://www.nogradgeopark.eu/en/sights/szent-istvan-cave", "tags": ["show_cave", "Bükk", "dripstone"]}'
),
(
  'a0000001-0000-0000-0000-000000000023',
  'Vass Imre-barlang',
  'Karst cave',
  'Aggtelek Karst',
  'Jósvafő',
  ST_SetSRID(ST_MakePoint(20.5367921, 48.4979658), 4326),
  2185, 56.6, true, 'restricted',
  '{"country": "HU", "geology": "limestone", "managed_by": "Aggtelek National Park", "show_cave": true, "source_note": "Depth field stores vertical extension from public speleological records.", "source_url": "https://anp.hu/en/tura/14/vass-imre-cave-tour-josvafo", "tags": ["guided tour", "Aggtelek Karst"]}'
),
(
  'a0000001-0000-0000-0000-000000000024',
  'Rákóczi-barlang',
  'Karst cave',
  'Aggtelek Karst',
  'Bódvarákó',
  ST_SetSRID(ST_MakePoint(20.752222, 48.519167), 4326),
  350, 44, true, 'restricted',
  '{"country": "HU", "geology": "limestone", "managed_by": "Aggtelek National Park", "show_cave": true, "source_note": "Dimensions use the official Aggtelek National Park public tour description.", "source_url": "https://anp.hu/en/tura/12/rakoczi-cave-tour-bodvarako", "tags": ["guided tour", "Aggtelek Karst"]}'
),
(
  'a0000001-0000-0000-0000-000000000025',
  'Béke-barlang',
  'Karst cave',
  'Aggtelek Karst',
  'Aggtelek',
  ST_SetSRID(ST_MakePoint(20.538, 48.465), 4326),
  7183, 97, true, 'restricted',
  '{"country": "HU", "geology": "limestone", "managed_by": "Aggtelek National Park", "show_cave": true, "source_note": "Coordinates are approximate public map coordinates; cave tours are controlled/registered.", "source_url": "https://anp.hu/en/tura/10/beke-cave-tour", "tags": ["guided tour", "UNESCO", "Aggtelek Karst"], "unesco": true}'
);

-- Tiered sample survey payloads for the added caves
INSERT INTO cave_surveys (cave_id, name, public_payload, caver_payload, scientific_payload) VALUES
(
  'a0000001-0000-0000-0000-000000000006',
  'Belianska jaskyňa Public Survey Sample 2026',
  '{"country": "SK", "kind": "karst", "protected": true, "region": "Belianske Tatry", "source_url": "https://www.ssj.sk/en/jaskyna/2-belianska-cave", "tags": ["show_cave", "Tatra National Park"]}',
  '{"access": "public show cave / guided route", "depth_m": 168, "difficulty": "easy", "equipment_required": ["comfortable shoes", "jacket"], "length_m": 3829}',
  '{"coordinate_accuracy": "public entrance coordinate; use as demo data, not official survey control", "data_quality": "public source sample data", "geology": "limestone"}'
),
(
  'a0000001-0000-0000-0000-000000000007',
  'Bystrianska jaskyňa Public Survey Sample 2026',
  '{"country": "SK", "kind": "karst", "protected": true, "region": "Nízke Tatry", "source_url": "https://www.ssj.sk/en/jaskyna/3-bystrianska-cave", "tags": ["show_cave", "Low Tatras"]}',
  '{"access": "public show cave / guided route", "depth_m": 99, "difficulty": "easy", "equipment_required": ["comfortable shoes", "jacket"], "length_m": 3531}',
  '{"coordinate_accuracy": "public entrance coordinate; use as demo data, not official survey control", "data_quality": "public source sample data", "geology": "limestone"}'
),
(
  'a0000001-0000-0000-0000-000000000008',
  'Demänovská jaskyňa slobody Public Survey Sample 2026',
  '{"country": "SK", "kind": "karst", "protected": true, "region": "Nízke Tatry", "source_url": "https://www.ssj.sk/en/jaskyna/4-demanovska-cave-of-liberty", "tags": ["show_cave", "Low Tatras", "Ramsar"]}',
  '{"access": "public show cave / guided route", "depth_m": 130, "difficulty": "easy", "equipment_required": ["comfortable shoes", "jacket"], "length_m": 11117}',
  '{"coordinate_accuracy": "public entrance coordinate; use as demo data, not official survey control", "data_quality": "public source sample data", "geology": "limestone", "hydrology": "Demänovka", "ramsar": true}'
),
(
  'a0000001-0000-0000-0000-000000000009',
  'Demänovská ľadová jaskyňa Public Survey Sample 2026',
  '{"country": "SK", "kind": "karst", "protected": true, "region": "Nízke Tatry", "source_url": "https://www.ssj.sk/en/jaskyna/5-demanovska-ice-cave", "tags": ["show_cave", "ice", "Low Tatras", "Ramsar"]}',
  '{"access": "public show cave / guided route", "depth_m": 57, "difficulty": "easy", "equipment_required": ["comfortable shoes", "jacket"], "length_m": 2445}',
  '{"coordinate_accuracy": "public entrance coordinate; use as demo data, not official survey control", "data_quality": "public source sample data", "geology": "limestone", "ice_cave": true, "ramsar": true}'
),
(
  'a0000001-0000-0000-0000-000000000010',
  'Dobšinská ľadová jaskyňa Public Survey Sample 2026',
  '{"country": "SK", "kind": "ice cave", "protected": true, "region": "Slovenský raj", "source_url": "https://www.ssj.sk/en/jaskyna/6-dobsinska-ice-cave", "tags": ["show_cave", "ice", "UNESCO", "Slovak Paradise"]}',
  '{"access": "public show cave / guided route", "depth_m": 75, "difficulty": "easy", "equipment_required": ["comfortable shoes", "jacket"], "length_m": 1491}',
  '{"coordinate_accuracy": "public entrance coordinate; use as demo data, not official survey control", "data_quality": "public source sample data", "geology": "limestone", "ice_cave": true, "unesco": true}'
),
(
  'a0000001-0000-0000-0000-000000000011',
  'Jaskyňa Driny Public Survey Sample 2026',
  '{"country": "SK", "kind": "karst", "protected": true, "region": "Malé Karpaty", "source_url": "https://www.ssj.sk/en/jaskyna/7-driny-cave", "tags": ["show_cave", "Little Carpathians"]}',
  '{"access": "public show cave / guided route", "depth_m": 40, "difficulty": "easy", "equipment_required": ["comfortable shoes", "jacket"], "length_m": 680}',
  '{"coordinate_accuracy": "public entrance coordinate; use as demo data, not official survey control", "data_quality": "public source sample data", "geology": "limestone"}'
),
(
  'a0000001-0000-0000-0000-000000000012',
  'Gombasecká jaskyňa Public Survey Sample 2026',
  '{"country": "SK", "kind": "karst", "protected": true, "region": "Slovak Karst", "source_url": "https://www.ssj.sk/en/jaskyna/8-gombasecka-cave", "tags": ["show_cave", "UNESCO", "Slovak Karst", "straw stalactites"]}',
  '{"access": "public show cave / guided route", "depth_m": 68, "difficulty": "easy", "equipment_required": ["comfortable shoes", "jacket"], "length_m": 3057}',
  '{"coordinate_accuracy": "public entrance coordinate; use as demo data, not official survey control", "data_quality": "public source sample data", "geology": "limestone", "unesco": true}'
),
(
  'a0000001-0000-0000-0000-000000000013',
  'Ochtinská aragonitová jaskyňa Public Survey Sample 2026',
  '{"country": "SK", "kind": "aragonite cave", "protected": true, "region": "Slovenské rudohorie", "source_url": "https://www.ssj.sk/en/jaskyna/9-ochtinska-aragonite-cave", "tags": ["show_cave", "UNESCO", "aragonite"]}',
  '{"access": "public show cave / guided route", "depth_m": 30, "difficulty": "easy", "equipment_required": ["comfortable shoes", "jacket"], "length_m": 585}',
  '{"coordinate_accuracy": "public entrance coordinate; use as demo data, not official survey control", "data_quality": "public source sample data", "geology": "crystalline limestone / aragonite", "unesco": true}'
),
(
  'a0000001-0000-0000-0000-000000000014',
  'Brestovská jaskyňa Public Survey Sample 2026',
  '{"country": "SK", "kind": "karst", "protected": true, "region": "Západné Tatry", "source_url": "https://www.ssj.sk/en/jaskyna/10-brestovska-cave", "tags": ["show_cave", "Western Tatras"]}',
  '{"access": "public show cave / guided route", "depth_m": 30, "difficulty": "easy", "equipment_required": ["comfortable shoes", "jacket"], "length_m": 1890}',
  '{"coordinate_accuracy": "public entrance coordinate; use as demo data, not official survey control", "data_quality": "public source sample data", "geology": "limestone", "hydrology": "active stream"}'
),
(
  'a0000001-0000-0000-0000-000000000015',
  'Krásnohorská jaskyňa Public Survey Sample 2026',
  '{"country": "SK", "kind": "karst", "protected": true, "region": "Slovak Karst", "source_url": "https://www.ssj.sk/en/clanok/210-krasnohorska-cave", "tags": ["show_cave", "UNESCO", "guided adventure route"]}',
  '{"access": "controlled guided access", "depth_m": null, "difficulty": "guided", "equipment_required": ["helmet", "lamp", "guide required"], "length_m": 1355, "source_note": "GPS converted from public tourism coordinates N48°37''5'''' E20°35''15''''; SSJ article gives known length 1355 m but not a single total depth value."}',
  '{"coordinate_accuracy": "public entrance coordinate; use as demo data, not official survey control", "data_quality": "public source sample data", "geology": "limestone", "unesco": true}'
),
(
  'a0000001-0000-0000-0000-000000000016',
  'Baradla-barlang Public Survey Sample 2026',
  '{"country": "HU", "kind": "karst", "protected": true, "region": "Aggtelek Karst", "source_url": "https://www.i-s-c-a.org/show-cave/133-baradla-cave", "tags": ["show_cave", "UNESCO", "Aggtelek Karst", "Baradla-Domica system"]}',
  '{"access": "public show cave / guided route", "depth_m": 103, "difficulty": "easy", "equipment_required": ["comfortable shoes", "jacket"], "length_m": 25500, "source_note": "Length stored as the commonly listed Baradla-Domica cross-border system figure; Hungarian Baradla-only length is often listed separately around 20.5 km."}',
  '{"coordinate_accuracy": "public entrance coordinate; use as demo data, not official survey control", "data_quality": "public source sample data", "geology": "limestone", "ramsar": true, "unesco": true}'
),
(
  'a0000001-0000-0000-0000-000000000017',
  'Pál-völgyi-barlang Public Survey Sample 2026',
  '{"country": "HU", "kind": "karst", "protected": true, "region": "Buda Hills", "source_url": "https://www.dunaipoly.hu/en/places/interpretation-sites/pal-volgyi-cave", "tags": ["show_cave", "Budapest", "thermal karst"]}',
  '{"access": "public show cave / guided route", "depth_m": 104, "difficulty": "easy", "equipment_required": ["comfortable shoes", "jacket"], "length_m": 32000, "source_note": "Budapest tourism material lists about 32 km for the cave system; older ISCA data lists a shorter mapped extent."}',
  '{"coordinate_accuracy": "public entrance coordinate; use as demo data, not official survey control", "data_quality": "public source sample data", "geology": "limestone / thermal-water formed"}'
),
(
  'a0000001-0000-0000-0000-000000000018',
  'Szemlő-hegyi-barlang Public Survey Sample 2026',
  '{"country": "HU", "kind": "karst", "protected": true, "region": "Buda Hills", "source_url": "https://www.dunaipoly.hu/en/places/interpretation-sites/szemlo-hegyi-cave", "tags": ["show_cave", "Budapest", "thermal karst"]}',
  '{"access": "public show cave / guided route", "depth_m": null, "difficulty": "easy", "equipment_required": ["comfortable shoes", "jacket"], "length_m": 2200}',
  '{"coordinate_accuracy": "public entrance coordinate; use as demo data, not official survey control", "data_quality": "public source sample data", "geology": "limestone / thermal-water formed"}'
),
(
  'a0000001-0000-0000-0000-000000000019',
  'Tapolcai-tavasbarlang Public Survey Sample 2026',
  '{"country": "HU", "kind": "lake cave", "protected": true, "region": "Balaton Uplands", "source_url": "https://www.bfnp.hu/en/oldal/about-the-lake-cave", "tags": ["show_cave", "lake cave", "boat tour", "Balaton Uplands"]}',
  '{"access": "public show cave / guided route", "depth_m": 20, "difficulty": "easy", "equipment_required": ["comfortable shoes", "jacket"], "length_m": 3300, "source_note": "Depth represents the public description of passages about 15-20 m below the town."}',
  '{"coordinate_accuracy": "public entrance coordinate; use as demo data, not official survey control", "data_quality": "public source sample data", "geology": "limestone / lake cave"}'
),
(
  'a0000001-0000-0000-0000-000000000020',
  'Abaligeti-barlang Public Survey Sample 2026',
  '{"country": "HU", "kind": "karst", "protected": true, "region": "Mecsek Mountains", "source_url": "https://www.abaliget.hu/en/turisztika/abaliget-cave/", "tags": ["show_cave", "Mecsek", "stream cave"]}',
  '{"access": "public show cave / guided route", "depth_m": 10, "difficulty": "easy", "equipment_required": ["comfortable shoes", "jacket"], "length_m": 1764}',
  '{"coordinate_accuracy": "public entrance coordinate; use as demo data, not official survey control", "data_quality": "public source sample data", "geology": "limestone"}'
),
(
  'a0000001-0000-0000-0000-000000000021',
  'Anna-barlang Public Survey Sample 2026',
  '{"country": "HU", "kind": "travertine cave", "protected": true, "region": "Bükk Mountains", "source_url": "https://www.miskolc.hu/en/life-city/tourism/sights/our-natural-resources/anna-cave", "tags": ["show_cave", "Bükk", "travertine"]}',
  '{"access": "public show cave / guided route", "depth_m": null, "difficulty": "easy", "equipment_required": ["comfortable shoes", "jacket"], "length_m": 570}',
  '{"coordinate_accuracy": "public entrance coordinate; use as demo data, not official survey control", "data_quality": "public source sample data", "geology": "travertine / limestone tufa"}'
),
(
  'a0000001-0000-0000-0000-000000000022',
  'Szent István-barlang Public Survey Sample 2026',
  '{"country": "HU", "kind": "dripstone cave", "protected": true, "region": "Bükk Mountains", "source_url": "https://www.nogradgeopark.eu/en/sights/szent-istvan-cave", "tags": ["show_cave", "Bükk", "dripstone"]}',
  '{"access": "public show cave / guided route", "depth_m": 101, "difficulty": "easy", "equipment_required": ["comfortable shoes", "jacket"], "length_m": 1514, "source_note": "Depth field stores the published vertical dimension."}',
  '{"coordinate_accuracy": "public entrance coordinate; use as demo data, not official survey control", "data_quality": "public source sample data", "geology": "Triassic limestone"}'
),
(
  'a0000001-0000-0000-0000-000000000023',
  'Vass Imre-barlang Public Survey Sample 2026',
  '{"country": "HU", "kind": "karst", "protected": true, "region": "Aggtelek Karst", "source_url": "https://anp.hu/en/tura/14/vass-imre-cave-tour-josvafo", "tags": ["guided tour", "Aggtelek Karst", "show_cave"]}',
  '{"access": "controlled guided access", "depth_m": 56.6, "difficulty": "guided", "equipment_required": ["helmet", "lamp", "guide required"], "length_m": 2185, "source_note": "Depth field stores vertical extension from public speleological records."}',
  '{"coordinate_accuracy": "public entrance coordinate; use as demo data, not official survey control", "data_quality": "public source sample data", "geology": "limestone"}'
),
(
  'a0000001-0000-0000-0000-000000000024',
  'Rákóczi-barlang Public Survey Sample 2026',
  '{"country": "HU", "kind": "karst", "protected": true, "region": "Aggtelek Karst", "source_url": "https://anp.hu/en/tura/12/rakoczi-cave-tour-bodvarako", "tags": ["guided tour", "Aggtelek Karst", "show_cave"]}',
  '{"access": "controlled guided access", "depth_m": 44, "difficulty": "guided", "equipment_required": ["helmet", "lamp", "guide required"], "length_m": 350, "source_note": "Dimensions use the official Aggtelek National Park public tour description."}',
  '{"coordinate_accuracy": "public entrance coordinate; use as demo data, not official survey control", "data_quality": "public source sample data", "geology": "limestone"}'
),
(
  'a0000001-0000-0000-0000-000000000025',
  'Béke-barlang Public Survey Sample 2026',
  '{"country": "HU", "kind": "karst", "protected": true, "region": "Aggtelek Karst", "source_url": "https://anp.hu/en/tura/10/beke-cave-tour", "tags": ["guided tour", "UNESCO", "Aggtelek Karst", "show_cave"]}',
  '{"access": "controlled guided access", "depth_m": 97, "difficulty": "guided", "equipment_required": ["helmet", "lamp", "guide required"], "length_m": 7183, "source_note": "Coordinates are approximate public map coordinates; cave tours are controlled/registered."}',
  '{"coordinate_accuracy": "public entrance coordinate; use as demo data, not official survey control", "data_quality": "public source sample data", "geology": "limestone", "unesco": true}'
);

-- One public/guided entrance per added cave
INSERT INTO cave_entrances (cave_id, name, geom, entrance_type, is_public) VALUES
('a0000001-0000-0000-0000-000000000006', 'Main public entrance', ST_SetSRID(ST_MakePoint(20.3115997, 49.2288017), 4326), 'tourist', true),
('a0000001-0000-0000-0000-000000000007', 'Main public entrance', ST_SetSRID(ST_MakePoint(19.5949001, 48.8395004), 4326), 'tourist', true),
('a0000001-0000-0000-0000-000000000008', 'Main public entrance', ST_SetSRID(ST_MakePoint(19.5851002, 48.9981003), 4326), 'tourist', true),
('a0000001-0000-0000-0000-000000000009', 'Main public entrance', ST_SetSRID(ST_MakePoint(19.5827999, 49.016201), 4326), 'tourist', true),
('a0000001-0000-0000-0000-000000000010', 'Main public entrance', ST_SetSRID(ST_MakePoint(20.3024998, 48.868), 4326), 'tourist', true),
('a0000001-0000-0000-0000-000000000011', 'Main public entrance', ST_SetSRID(ST_MakePoint(17.4020996, 48.5004005), 4326), 'tourist', true),
('a0000001-0000-0000-0000-000000000012', 'Main public entrance', ST_SetSRID(ST_MakePoint(20.4664993, 48.5628014), 4326), 'tourist', true),
('a0000001-0000-0000-0000-000000000013', 'Main public entrance', ST_SetSRID(ST_MakePoint(20.3092003, 48.6646004), 4326), 'tourist', true),
('a0000001-0000-0000-0000-000000000014', 'Main public entrance', ST_SetSRID(ST_MakePoint(19.6609001, 49.2588997), 4326), 'tourist', true),
('a0000001-0000-0000-0000-000000000015', 'Guided tour entrance', ST_SetSRID(ST_MakePoint(20.5875, 48.6180556), 4326), 'tourist', false),
('a0000001-0000-0000-0000-000000000016', 'Main public entrance', ST_SetSRID(ST_MakePoint(20.495097, 48.471534), 4326), 'tourist', true),
('a0000001-0000-0000-0000-000000000017', 'Main public entrance', ST_SetSRID(ST_MakePoint(19.0162, 47.5329), 4326), 'tourist', true),
('a0000001-0000-0000-0000-000000000018', 'Main public entrance', ST_SetSRID(ST_MakePoint(19.0242, 47.5277), 4326), 'tourist', true),
('a0000001-0000-0000-0000-000000000019', 'Main public entrance', ST_SetSRID(ST_MakePoint(17.443221, 46.883115), 4326), 'tourist', true),
('a0000001-0000-0000-0000-000000000020', 'Main public entrance', ST_SetSRID(ST_MakePoint(18.116235, 46.136679), 4326), 'tourist', true),
('a0000001-0000-0000-0000-000000000021', 'Main public entrance', ST_SetSRID(ST_MakePoint(20.6248645782, 48.1050987244), 4326), 'tourist', true),
('a0000001-0000-0000-0000-000000000022', 'Main public entrance', ST_SetSRID(ST_MakePoint(20.621374, 48.099893), 4326), 'tourist', true),
('a0000001-0000-0000-0000-000000000023', 'Guided tour entrance', ST_SetSRID(ST_MakePoint(20.5367921, 48.4979658), 4326), 'tourist', false),
('a0000001-0000-0000-0000-000000000024', 'Guided tour entrance', ST_SetSRID(ST_MakePoint(20.752222, 48.519167), 4326), 'tourist', false),
('a0000001-0000-0000-0000-000000000025', 'Guided tour entrance', ST_SetSRID(ST_MakePoint(20.538, 48.465), 4326), 'tourist', false);

-- Schematic lines for map demos; do not treat as official passage surveys
INSERT INTO cave_survey_lines (cave_id, geom, payload) VALUES
(
  'a0000001-0000-0000-0000-000000000006',
  ST_SetSRID(ST_GeomFromText('LINESTRING(20.311600 49.228802, 20.312350 49.229739, 20.312589 49.230988, 20.312227 49.232347)'), 4326),
  '{"passage_name": "schematic main passage", "source_note": "Generated schematic line from public entrance coordinate; not an official cave survey.", "source_url": "https://www.ssj.sk/en/jaskyna/2-belianska-cave", "surveyed_by": "sample_data_schematic", "year": 2026}'
),
(
  'a0000001-0000-0000-0000-000000000007',
  ST_SetSRID(ST_GeomFromText('LINESTRING(19.594900 48.839500, 19.594935 48.840700, 19.594375 48.841842, 19.593267 48.842709)'), 4326),
  '{"passage_name": "schematic main passage", "source_note": "Generated schematic line from public entrance coordinate; not an official cave survey.", "source_url": "https://www.ssj.sk/en/jaskyna/3-bystrianska-cave", "surveyed_by": "sample_data_schematic", "year": 2026}'
),
(
  'a0000001-0000-0000-0000-000000000008',
  ST_SetSRID(ST_GeomFromText('LINESTRING(19.585100 48.998100, 19.584406 48.999079, 19.583271 48.999654, 19.581865 48.999680)'), 4326),
  '{"passage_name": "schematic main passage", "source_note": "Generated schematic line from public entrance coordinate; not an official cave survey.", "source_url": "https://www.ssj.sk/en/jaskyna/4-demanovska-cave-of-liberty", "surveyed_by": "sample_data_schematic", "year": 2026}'
),
(
  'a0000001-0000-0000-0000-000000000009',
  ST_SetSRID(ST_GeomFromText('LINESTRING(19.582800 49.016201, 19.581657 49.016565, 19.580404 49.016341, 19.579266 49.015516)'), 4326),
  '{"passage_name": "schematic main passage", "source_note": "Generated schematic line from public entrance coordinate; not an official cave survey.", "source_url": "https://www.ssj.sk/en/jaskyna/5-demanovska-ice-cave", "surveyed_by": "sample_data_schematic", "year": 2026}'
),
(
  'a0000001-0000-0000-0000-000000000010',
  ST_SetSRID(ST_GeomFromText('LINESTRING(20.302500 48.868000, 20.301367 48.867603, 20.300502 48.866670, 20.300090 48.865326)'), 4326),
  '{"passage_name": "schematic main passage", "source_note": "Generated schematic line from public entrance coordinate; not an official cave survey.", "source_url": "https://www.ssj.sk/en/jaskyna/6-dobsinska-ice-cave", "surveyed_by": "sample_data_schematic", "year": 2026}'
),
(
  'a0000001-0000-0000-0000-000000000011',
  ST_SetSRID(ST_GeomFromText('LINESTRING(17.402100 48.500400, 17.401434 48.499402, 17.401304 48.498136, 17.401784 48.496814)'), 4326),
  '{"passage_name": "schematic main passage", "source_note": "Generated schematic line from public entrance coordinate; not an official cave survey.", "source_url": "https://www.ssj.sk/en/jaskyna/7-driny-cave", "surveyed_by": "sample_data_schematic", "year": 2026}'
),
(
  'a0000001-0000-0000-0000-000000000012',
  ST_SetSRID(ST_GeomFromText('LINESTRING(20.466499 48.562801, 20.466569 48.561603, 20.467227 48.560514, 20.468406 48.559747)'), 4326),
  '{"passage_name": "schematic main passage", "source_note": "Generated schematic line from public entrance coordinate; not an official cave survey.", "source_url": "https://www.ssj.sk/en/jaskyna/8-gombasecka-cave", "surveyed_by": "sample_data_schematic", "year": 2026}'
),
(
  'a0000001-0000-0000-0000-000000000013',
  ST_SetSRID(ST_GeomFromText('LINESTRING(20.309200 48.664600, 20.309977 48.663686, 20.311158 48.663212, 20.312561 48.663309)'), 4326),
  '{"passage_name": "schematic main passage", "source_note": "Generated schematic line from public entrance coordinate; not an official cave survey.", "source_url": "https://www.ssj.sk/en/jaskyna/9-ochtinska-aragonite-cave", "surveyed_by": "sample_data_schematic", "year": 2026}'
),
(
  'a0000001-0000-0000-0000-000000000014',
  ST_SetSRID(ST_GeomFromText('LINESTRING(19.660900 49.258900, 19.662071 49.258636, 19.663299 49.258969, 19.664361 49.259890)'), 4326),
  '{"passage_name": "schematic main passage", "source_note": "Generated schematic line from public entrance coordinate; not an official cave survey.", "source_url": "https://www.ssj.sk/en/jaskyna/10-brestovska-cave", "surveyed_by": "sample_data_schematic", "year": 2026}'
),
(
  'a0000001-0000-0000-0000-000000000015',
  ST_SetSRID(ST_GeomFromText('LINESTRING(20.587500 48.618056, 20.588593 48.618550, 20.589374 48.619554, 20.589668 48.620930)'), 4326),
  '{"passage_name": "schematic main passage", "source_note": "Generated schematic line from public entrance coordinate; not an official cave survey.", "source_url": "https://www.ssj.sk/en/clanok/210-krasnohorska-cave", "surveyed_by": "sample_data_schematic", "year": 2026}'
),
(
  'a0000001-0000-0000-0000-000000000016',
  ST_SetSRID(ST_GeomFromText('LINESTRING(20.495097 48.471534, 20.495673 48.472587, 20.495692 48.473859, 20.495099 48.475134)'), 4326),
  '{"passage_name": "schematic main passage", "source_note": "Generated schematic line from public entrance coordinate; not an official cave survey.", "source_url": "https://www.i-s-c-a.org/show-cave/133-baradla-cave", "surveyed_by": "sample_data_schematic", "year": 2026}'
),
(
  'a0000001-0000-0000-0000-000000000017',
  ST_SetSRID(ST_GeomFromText('LINESTRING(19.016200 47.532900, 19.016026 47.534087, 19.015276 47.535115, 19.014035 47.535776)'), 4326),
  '{"passage_name": "schematic main passage", "source_note": "Generated schematic line from public entrance coordinate; not an official cave survey.", "source_url": "https://www.dunaipoly.hu/en/places/interpretation-sites/pal-volgyi-cave", "surveyed_by": "sample_data_schematic", "year": 2026}'
),
(
  'a0000001-0000-0000-0000-000000000018',
  ST_SetSRID(ST_GeomFromText('LINESTRING(19.024200 47.527700, 19.023347 47.528544, 19.022129 47.528913, 19.020740 47.528694)'), 4326),
  '{"passage_name": "schematic main passage", "source_note": "Generated schematic line from public entrance coordinate; not an official cave survey.", "source_url": "https://www.dunaipoly.hu/en/places/interpretation-sites/szemlo-hegyi-cave", "surveyed_by": "sample_data_schematic", "year": 2026}'
),
(
  'a0000001-0000-0000-0000-000000000019',
  ST_SetSRID(ST_GeomFromText('LINESTRING(17.443221 46.883115, 17.442032 46.883275, 17.440837 46.882837, 17.439859 46.881827)'), 4326),
  '{"passage_name": "schematic main passage", "source_note": "Generated schematic line from public entrance coordinate; not an official cave survey.", "source_url": "https://www.bfnp.hu/en/oldal/about-the-lake-cave", "surveyed_by": "sample_data_schematic", "year": 2026}'
),
(
  'a0000001-0000-0000-0000-000000000020',
  ST_SetSRID(ST_GeomFromText('LINESTRING(18.116235 46.136679, 18.115189 46.136091, 18.114498 46.135022, 18.114326 46.133627)'), 4326),
  '{"passage_name": "schematic main passage", "source_note": "Generated schematic line from public entrance coordinate; not an official cave survey.", "source_url": "https://www.abaliget.hu/en/turisztika/abaliget-cave/", "surveyed_by": "sample_data_schematic", "year": 2026}'
),
(
  'a0000001-0000-0000-0000-000000000021',
  ST_SetSRID(ST_GeomFromText('LINESTRING(20.624865 48.105099, 20.624383 48.104000, 20.624475 48.102731, 20.625177 48.101512)'), 4326),
  '{"passage_name": "schematic main passage", "source_note": "Generated schematic line from public entrance coordinate; not an official cave survey.", "source_url": "https://www.miskolc.hu/en/life-city/tourism/sights/our-natural-resources/anna-cave", "surveyed_by": "sample_data_schematic", "year": 2026}'
),
(
  'a0000001-0000-0000-0000-000000000022',
  ST_SetSRID(ST_GeomFromText('LINESTRING(20.621374 48.099893, 20.621651 48.098725, 20.622488 48.097767, 20.623782 48.097216)'), 4326),
  '{"passage_name": "schematic main passage", "source_note": "Generated schematic line from public entrance coordinate; not an official cave survey.", "source_url": "https://www.nogradgeopark.eu/en/sights/szent-istvan-cave", "surveyed_by": "sample_data_schematic", "year": 2026}'
),
(
  'a0000001-0000-0000-0000-000000000023',
  ST_SetSRID(ST_GeomFromText('LINESTRING(20.536792 48.497966, 20.537716 48.497200, 20.538961 48.496938, 20.540326 48.497277)'), 4326),
  '{"passage_name": "schematic main passage", "source_note": "Generated schematic line from public entrance coordinate; not an official cave survey.", "source_url": "https://anp.hu/en/tura/14/vass-imre-cave-tour-josvafo", "surveyed_by": "sample_data_schematic", "year": 2026}'
),
(
  'a0000001-0000-0000-0000-000000000024',
  ST_SetSRID(ST_GeomFromText('LINESTRING(20.752222 48.519167, 20.753421 48.519111, 20.754573 48.519652, 20.755458 48.520744)'), 4326),
  '{"passage_name": "schematic main passage", "source_note": "Generated schematic line from public entrance coordinate; not an official cave survey.", "source_url": "https://anp.hu/en/tura/12/rakoczi-cave-tour-bodvarako", "surveyed_by": "sample_data_schematic", "year": 2026}'
),
(
  'a0000001-0000-0000-0000-000000000025',
  ST_SetSRID(ST_GeomFromText('LINESTRING(20.538000 48.465000, 20.538991 48.465677, 20.539586 48.466802, 20.539636 48.468207)'), 4326),
  '{"passage_name": "schematic main passage", "source_note": "Generated schematic line from public entrance coordinate; not an official cave survey.", "source_url": "https://anp.hu/en/tura/10/beke-cave-tour", "surveyed_by": "sample_data_schematic", "year": 2026}'
);

-- ── Additional Slovak caves, batch 2 ─────────────────────────────────────
-- Adds 20 more Slovakia-only cave records after ids ...000026 to ...000045.
-- Sources are public tourist/SSJ/geosite pages. Some coordinates are approximate
-- public locality points where the source gives a locality but no official GPS.
-- Schematic cave_survey_lines are generated demo geometry, not official surveys.

INSERT INTO caves (id, name, cave_type, region, municipality, geom, length_m, depth_m, is_public, sensitivity_level, payload) VALUES
(
  'a0000001-0000-0000-0000-000000000026',
  'Malá Stanišovská jaskyňa',
  'Karst cave',
  'Žilina',
  'Liptovský Ján',
  ST_SetSRID(ST_MakePoint(19.674167, 49.008056), 4326),
  871, 28, true, 'public',
  '{"source_url":"https://www.visitliptov.sk/zaujimavosti/stanisovska-jaskyna-janska-dolina/","source_note":"Visit Liptov lists Malá Stanišovská Cave with length 871 m, depth 28 m and GPS N 49°00''29\", E 19°40''27\". SSJ describes the wider Stanišovská cave group.","protected":true,"unesco":false,"tags":["karst","show_cave","headlamp_tour","liptov"],"features":["unlit guided cave","Stanišovské cave group","bats"],"geology":"Middle Triassic Gutenstein limestone","difficulty":"easy","equipment":["helmet","lamp","sturdy shoes","jacket"],"tour_length_m":410,"temperature_c":7,"is_approx":false,"sample_data_note":"Real public cave record; schematic survey line below is generated for map demos, not an official cave survey."}'
),
(
  'a0000001-0000-0000-0000-000000000027',
  'Jaskyňa mŕtvych netopierov',
  'High-mountain karst cave',
  'Banská Bystrica',
  'Brezno',
  ST_SetSRID(ST_MakePoint(19.640278, 48.925833), 4326),
  19885, 324, true, 'restricted',
  '{"source_url":"https://www.visitliptov.sk/en/interests/dead-bats-cave-low-tatras/","source_note":"Visit Liptov lists the underground labyrinth as 19,885 m long and 324 m deep; Slovakia Travel gives public GPS N48°55''33\" E19°38''25\".","protected":true,"unesco":false,"tags":["karst","other_show_cave","adventure_tour","low_tatras"],"features":["14 known levels","bat bone finds","Bystrický Dome","alpine cave"],"geology":"limestone in the Ďumbier high-mountain karst","difficulty":"hard","equipment":["helmet","lamp","warm clothes","sturdy shoes"],"tour_length_m":1000,"temperature_c":4,"elevation_m":1520,"is_approx":false,"sample_data_note":"Real public cave record; schematic survey line below is generated for map demos, not an official cave survey."}'
),
(
  'a0000001-0000-0000-0000-000000000028',
  'Zlá diera',
  'Karst cave',
  'Prešov',
  'Lipovce',
  ST_SetSRID(ST_MakePoint(20.943889, 49.053333), 4326),
  NULL, NULL, true, 'public',
  '{"source_url":"https://slovakia.travel/en/zla-diera-cave","source_note":"Slovakia Travel gives GPS N49°3''12\" E20°56''38\" and describes it as the only accessible cave in north-east Slovakia; trustworthy total length/depth not inserted here.","protected":true,"unesco":false,"tags":["karst","other_show_cave","unlit","saris"],"features":["unlit guided cave","traditional carbide lamp tours","only accessible cave in Prešov district"],"geology":"limestone and dolomite in Bachureň/Branisko area","difficulty":"medium","equipment":["helmet","lamp","sturdy shoes","warm clothes"],"tour_length_m":800,"temperature_c":7,"is_approx":false,"sample_data_note":"Real public cave record; schematic survey line below is generated for map demos, not an official cave survey."}'
),
(
  'a0000001-0000-0000-0000-000000000029',
  'Prepoštská jaskyňa',
  'Travertine cave / rock shelter',
  'Trenčín',
  'Bojnice',
  ST_SetSRID(ST_MakePoint(18.583333, 48.777778), 4326),
  14, NULL, true, 'public',
  '{"source_url":"https://www.ssj.sk/en/clanok/220-prepostska-cave","source_note":"SSJ describes an internal space of about 6 m plus a narrow 8 m passage; Slovakia Travel gives GPS N48°46''40\" E18°35''0\".","protected":true,"unesco":false,"tags":["travertine","archaeology","museum","neanderthal_site"],"features":["prehistoric museum","rock overhang","important archaeological site"],"geology":"travertine formed by mineral spring activity","difficulty":"easy","equipment":["normal visitor clothing"],"elevation_m":242,"is_approx":false,"sample_data_note":"Real public cave record; schematic survey line below is generated for map demos, not an official cave survey."}'
),
(
  'a0000001-0000-0000-0000-000000000030',
  'Bojnická hradná jaskyňa',
  'Travertine cave',
  'Trenčín',
  'Bojnice',
  ST_SetSRID(ST_MakePoint(18.577778, 48.780000), 4326),
  NULL, NULL, true, 'public',
  '{"source_url":"https://slovakia.travel/en/bojnicka-hradna-jaskyna-cave","source_note":"Slovakia Travel gives GPS N48°46''48\" E18°34''40\" and describes a 22 m diameter, 6 m high natural cave 26 m below the fourth courtyard.","protected":true,"unesco":false,"tags":["travertine","castle_cave","tourism"],"features":["circular chamber","diameter about 22 m","height about 6 m","castle well"],"geology":"travertine cave below Bojnice Castle","difficulty":"easy","equipment":["normal visitor clothing"],"diameter_m":22,"height_m":6,"below_courtyard_m":26,"is_approx":false,"sample_data_note":"Real public cave record; schematic survey line below is generated for map demos, not an official cave survey."}'
),
(
  'a0000001-0000-0000-0000-000000000031',
  'Okno Cave',
  'Fluvial karst cave',
  'Žilina',
  'Demänovská Dolina',
  ST_SetSRID(ST_MakePoint(19.582900, 49.014800), 4326),
  2570, 110, false, 'restricted',
  '{"source_url":"https://www.ssj.sk/en/clanok/216-okno-cave","source_note":"SSJ gives length 2,570 m, vertical span 110 m and location in the Okno cliff at 915 m elevation. Coordinate is an approximate public map point in the Demänovská Valley, not an official entrance coordinate.","protected":true,"unesco":false,"tags":["karst","national_nature_monument","demanovska_valley","archaeology"],"features":["old tourist cave","flowstone fill","bat locality","archaeological finds"],"geology":"dark Middle Triassic limestone of the Krížna Nappe","difficulty":"restricted","equipment":["permit required"],"temperature_c":6.2,"elevation_m":915,"is_approx":true,"sample_data_note":"Real public cave record; schematic survey line below is generated for map demos, not an official cave survey."}'
),
(
  'a0000001-0000-0000-0000-000000000032',
  'Drienovská jaskyňa',
  'Spring river cave',
  'Košice',
  'Drienovec',
  ST_SetSRID(ST_MakePoint(20.919000, 48.623900), 4326),
  1348, 85, false, 'restricted',
  '{"source_url":"https://www.ssj.sk/en/clanok/201-drienovska-cave","source_note":"SSJ gives length 1,348 m, vertical span 85 m and location north of Drienovec at the mouth of the Miglinc Valley. Coordinate is approximate public map placement.","protected":true,"unesco":true,"tags":["karst","national_nature_monument","slovak_karst","bats"],"features":["underground stream","lakes","cascades","gypsum crusts","important bat locality"],"geology":"Middle Triassic Wetterstein limestone of the Silica Nappe","difficulty":"restricted","equipment":["permit required"],"is_approx":true,"sample_data_note":"Real public cave record; schematic survey line below is generated for map demos, not an official cave survey."}'
),
(
  'a0000001-0000-0000-0000-000000000033',
  'Jaskyňa Zlomísk',
  'Large karst cave system',
  'Žilina',
  'Liptovský Ján',
  ST_SetSRID(ST_MakePoint(19.675500, 49.018000), 4326),
  10688, 147, false, 'restricted',
  '{"source_url":"https://www.ssj.sk/en/clanok/207-zlomisk-cave","source_note":"SSJ gives length 10,688 m, vertical span 147 m and location in the central karst of Jánska Valley. Coordinate is approximate public map placement.","protected":true,"unesco":false,"tags":["karst","national_nature_monument","janska_valley","low_tatras"],"features":["large cave system","two known entrances","horizontal passages","vertical connections"],"geology":"Middle Triassic Gutenstein limestone of the Choč Nappe","difficulty":"restricted","equipment":["permit required","technical caving gear"],"elevation_m":809,"is_approx":true,"sample_data_note":"Real public cave record; schematic survey line below is generated for map demos, not an official cave survey."}'
),
(
  'a0000001-0000-0000-0000-000000000034',
  'Hrušovská jaskyňa',
  'Spring cave',
  'Košice',
  'Hrušov',
  ST_SetSRID(ST_MakePoint(20.635000, 48.589000), 4326),
  780, NULL, false, 'restricted',
  '{"source_url":"https://www.ssj.sk/en/clanok/186-natural-world-heritage-the-slovak-karst","source_note":"SSJ''s Slovak Karst world-heritage overview gives length 780 m and location close to Hrušov on the eastern foothill of the Silická Plateau. Coordinate is approximate public map placement.","protected":true,"unesco":true,"tags":["karst","slovak_karst","world_heritage","spring_cave"],"features":["underground stream","helictites","calcite crystals","flowstone shield"],"geology":"limestone cave on the eastern foothill of the Silická Plateau","difficulty":"restricted","equipment":["permit required"],"is_approx":true,"sample_data_note":"Real public cave record; schematic survey line below is generated for map demos, not an official cave survey."}'
),
(
  'a0000001-0000-0000-0000-000000000035',
  'Skalistý potok Cave',
  'Spring river cave',
  'Košice',
  'Háj',
  ST_SetSRID(ST_MakePoint(20.857500, 48.626800), 4326),
  5855, 317, false, 'highly_restricted',
  '{"source_url":"https://www.ssj.sk/en/clanok/186-natural-world-heritage-the-slovak-karst","source_note":"SSJ''s Slovak Karst overview gives length 5,855 m and vertical distance 317 m near Háj. Coordinate is approximate public map placement.","protected":true,"unesco":true,"tags":["karst","slovak_karst","world_heritage","siphons","speleodiving"],"features":["underground stream","siphons","lakes","rapids","waterfalls"],"geology":"karst cave at the southern foothill of the Jasovská Plateau","difficulty":"technical","equipment":["permit required","technical caving gear","diving equipment in siphon sections"],"is_approx":true,"sample_data_note":"Real public cave record; schematic survey line below is generated for map demos, not an official cave survey."}'
),
(
  'a0000001-0000-0000-0000-000000000036',
  'Kunia priepasť',
  'Abyss cave',
  'Košice',
  'Háj',
  ST_SetSRID(ST_MakePoint(20.842500, 48.638000), 4326),
  813, 203, false, 'highly_restricted',
  '{"source_url":"https://www.ssj.sk/en/clanok/186-natural-world-heritage-the-slovak-karst","source_note":"SSJ gives length 813 m and depth 203 m for Kunia Abyss on the southern edge of the Jasovská Plateau. Coordinate is approximate public map placement.","protected":true,"unesco":true,"tags":["abyss","karst","slovak_karst","vertical"],"features":["cascading shafts","horizontal passages","flowstone fills","possible hydrological link to Skalistý potok"],"geology":"karst abyss on the southern edge of the Jasovská Plateau","difficulty":"technical","equipment":["permit required","vertical caving gear"],"is_approx":true,"sample_data_note":"Real public cave record; schematic survey line below is generated for map demos, not an official cave survey."}'
),
(
  'a0000001-0000-0000-0000-000000000037',
  'Diviačia priepasť',
  'Abyss cave',
  'Košice',
  'Plešivec',
  ST_SetSRID(ST_MakePoint(20.466000, 48.595000), 4326),
  NULL, 123, false, 'highly_restricted',
  '{"source_url":"https://www.ssj.sk/en/clanok/186-natural-world-heritage-the-slovak-karst","source_note":"SSJ gives depth 123 m and location at the eastern edge of the Plešivská Plateau. Coordinate is approximate public map placement.","protected":true,"unesco":true,"tags":["abyss","karst","slovak_karst","vertical"],"features":["corrosion-collapse abyss","flowstone decoration","water lilies and cave pearls"],"geology":"karst abyss on the eastern edge of the Plešivská Plateau","difficulty":"technical","equipment":["permit required","vertical caving gear"],"is_approx":true,"sample_data_note":"Real public cave record; schematic survey line below is generated for map demos, not an official cave survey."}'
),
(
  'a0000001-0000-0000-0000-000000000038',
  'Zvonivá jama',
  'Abyss cave',
  'Košice',
  'Plešivec',
  ST_SetSRID(ST_MakePoint(20.435000, 48.565000), 4326),
  220, 101, false, 'highly_restricted',
  '{"source_url":"https://www.ssj.sk/en/clanok/186-natural-world-heritage-the-slovak-karst","source_note":"SSJ gives depth 101 m and adjacent horizontal passages 220 m long in the central Plešivská Plateau. Coordinate is approximate public map placement.","protected":true,"unesco":true,"tags":["abyss","karst","slovak_karst","vertical"],"features":["corrosion-collapse abyss","underground dome","pagoda stalagmites"],"geology":"karst abyss in the central Plešivská Plateau","difficulty":"technical","equipment":["permit required","vertical caving gear"],"is_approx":true,"sample_data_note":"Real public cave record; schematic survey line below is generated for map demos, not an official cave survey."}'
),
(
  'a0000001-0000-0000-0000-000000000039',
  'Obrovská priepasť',
  'Abyss cave',
  'Košice',
  'Jablonov nad Turňou',
  ST_SetSRID(ST_MakePoint(20.675000, 48.610000), 4326),
  NULL, 100, false, 'highly_restricted',
  '{"source_url":"https://www.ssj.sk/en/clanok/186-natural-world-heritage-the-slovak-karst","source_note":"SSJ describes Obrovská Abyss above Jablonov nad Turnou on the Dolný vrch Plateau and gives shaft depth 100 m. Coordinate is approximate public map placement.","protected":true,"unesco":true,"tags":["abyss","karst","slovak_karst","vertical"],"features":["corrosion-collapse shaft","Dolný vrch Plateau"],"geology":"karst abyss on the Dolný vrch Plateau","difficulty":"technical","equipment":["permit required","vertical caving gear"],"is_approx":true,"sample_data_note":"Real public cave record; schematic survey line below is generated for map demos, not an official cave survey."}'
),
(
  'a0000001-0000-0000-0000-000000000040',
  'Snežná diera',
  'Ice abyss cave',
  'Košice',
  'Zádiel',
  ST_SetSRID(ST_MakePoint(20.816000, 48.623500), 4326),
  100, 25, false, 'restricted',
  '{"source_url":"https://www.ssj.sk/en/clanok/186-natural-world-heritage-the-slovak-karst","source_note":"SSJ gives length 100 m and depth 25 m in the Horný vrch Plateau north of the upper Zádielska Gorge. Coordinate is approximate public map placement.","protected":true,"unesco":true,"tags":["abyss","ice","karst","slovak_karst"],"features":["permanent ice fill","crevasse-corrosion cave","Horný vrch Plateau"],"geology":"crevasse-corrosion gravitationally widened fissure","difficulty":"restricted","equipment":["permit required"],"is_approx":true,"sample_data_note":"Real public cave record; schematic survey line below is generated for map demos, not an official cave survey."}'
),
(
  'a0000001-0000-0000-0000-000000000041',
  'Jaskyňa v Havranej skale',
  'Karst cave',
  'Košice',
  'Stratená',
  ST_SetSRID(ST_MakePoint(20.344044, 48.890602), 4326),
  NULL, NULL, true, 'public',
  '{"source_url":"https://www.ssj.sk/sk/verejnosti-volne-pristupne-jaskyne","source_note":"SSJ lists Jaskyňa v Havranej skale among caves freely open to the public. GPS is taken from a public hiking/video listing and should be treated as public approximate data.","protected":true,"unesco":false,"tags":["karst","freely_accessible","slovak_paradise"],"features":["freely accessible cave","Havrania skala area","hiking route"],"geology":"karst cave in Slovenský raj / Stratenská hornatina area","difficulty":"medium","equipment":["lamp","sturdy shoes"],"elevation_m":1128,"is_approx":true,"sample_data_note":"Real public cave record; schematic survey line below is generated for map demos, not an official cave survey."}'
),
(
  'a0000001-0000-0000-0000-000000000042',
  'Zelená jaskyňa',
  'Karst cave',
  'Košice',
  'Dobšiná',
  ST_SetSRID(ST_MakePoint(20.309810, 48.859180), 4326),
  NULL, NULL, true, 'public',
  '{"source_url":"https://www.kamnavylet.sk/sk/atrakcia/zelena-jaskyna","source_note":"KamNaVylet gives GPS 48.85918, 20.30981 and describes it as freely accessible; SSJ also lists Zelená jaskyňa among freely open caves.","protected":true,"unesco":false,"tags":["karst","freely_accessible","slovak_paradise"],"features":["freely accessible cave","near Dobšinská Ice Cave","spacious chamber"],"geology":"karst cave in the Slovak Paradise area","difficulty":"easy","equipment":["lamp","sturdy shoes"],"is_approx":false,"sample_data_note":"Real public cave record; schematic survey line below is generated for map demos, not an official cave survey."}'
),
(
  'a0000001-0000-0000-0000-000000000043',
  'Mažarná',
  'Karst cave / rock shelter',
  'Žilina',
  'Blatnica',
  ST_SetSRID(ST_MakePoint(18.960278, 48.939444), 4326),
  130, NULL, true, 'public',
  '{"source_url":"https://www.outdooractive.com/en/route/hiking-trail/nagy-fatra/route-to-mazarna-cave/802405254/","source_note":"Outdooractive describes Mažarná as about 130 m long; Wikimedia Commons photo metadata provides public GPS near 48°56''22\"N, 18°57''37\"E.","protected":true,"unesco":false,"tags":["karst","freely_accessible","great_fatra","archaeology"],"features":["large cave in Veľká Fatra","Bronze Age finds","cave bear bones"],"geology":"karst cave in a limestone cliff of Veľká Fatra","difficulty":"medium","equipment":["lamp","sturdy shoes"],"elevation_m":830,"is_approx":false,"sample_data_note":"Real public cave record; schematic survey line below is generated for map demos, not an official cave survey."}'
),
(
  'a0000001-0000-0000-0000-000000000044',
  'Čertova pec',
  'Karst cave / archaeological site',
  'Nitra',
  'Radošina',
  ST_SetSRID(ST_MakePoint(17.937000, 48.549000), 4326),
  27, NULL, true, 'public',
  '{"source_url":"https://en.wikipedia.org/wiki/%C4%8Certova_pec","source_note":"Wikipedia summarizes the cave as 27 m long and near Radošina; SSJ lists Čertova pec among caves freely open to public.","protected":true,"unesco":false,"tags":["karst","freely_accessible","archaeology","paleolithic"],"features":["Palaeolithic site","small cave","recreational locality"],"geology":"small karst cave in Považský Inovec","difficulty":"easy","equipment":["lamp optional"],"is_approx":true,"sample_data_note":"Real public cave record; schematic survey line below is generated for map demos, not an official cave survey."}'
),
(
  'a0000001-0000-0000-0000-000000000045',
  'Pružinská Dúpna jaskyňa',
  'Karst cave',
  'Trenčín',
  'Pružina',
  ST_SetSRID(ST_MakePoint(18.502660, 48.999700), 4326),
  300, NULL, true, 'public',
  '{"source_url":"https://visit.trencin.sk/pruzinska-dupna-jaskyna/","source_note":"Visit Trenčín gives GPS 49°00''03\"N, 18°30''17\"E; a public hiking photo description states the cave is over 300 m long. SSJ lists it among freely open caves.","protected":true,"unesco":false,"tags":["karst","freely_accessible","strážovské_vrchy","archaeology","bats"],"features":["one of the oldest known caves in Slovakia","cave lion and cave bear bones","seasonal/guided access"],"geology":"karst cave in the Čierny vrch massif above Rečica valley","difficulty":"medium","equipment":["lamp","sturdy shoes"],"elevation_m":590,"is_approx":false,"sample_data_note":"Real public cave record; schematic survey line below is generated for map demos, not an official cave survey."}'
);

INSERT INTO cave_surveys (cave_id, name, public_payload, caver_payload, scientific_payload) VALUES
(
  'a0000001-0000-0000-0000-000000000026',
  'Malá Stanišovská jaskyňa public-source survey 2026',
  '{"kind":"karst cave","tags":["karst","show_cave","headlamp_tour","liptov"],"protected":true,"region":"Žilina","source_url":"https://www.visitliptov.sk/zaujimavosti/stanisovska-jaskyna-janska-dolina/","source_note":"Visit Liptov lists Malá Stanišovská Cave with length 871 m, depth 28 m and GPS N 49°00''29\", E 19°40''27\". SSJ describes the wider Stanišovská cave group."}',
  '{"length_m":871,"depth_m":28,"difficulty":"easy","equipment_required":["helmet","lamp","sturdy shoes","jacket"],"notable_features":["unlit guided cave","Stanišovské cave group","bats"],"coordinate_quality":"public_gps_coordinate"}',
  '{"geology":"Middle Triassic Gutenstein limestone","source_url":"https://www.visitliptov.sk/zaujimavosti/stanisovska-jaskyna-janska-dolina/","source_note":"Visit Liptov lists Malá Stanišovská Cave with length 871 m, depth 28 m and GPS N 49°00''29\", E 19°40''27\". SSJ describes the wider Stanišovská cave group.","sample_data_quality":"public sourced; not a cave registry export"}'
),
(
  'a0000001-0000-0000-0000-000000000027',
  'Jaskyňa mŕtvych netopierov public-source survey 2026',
  '{"kind":"high-mountain karst cave","tags":["karst","other_show_cave","adventure_tour","low_tatras"],"protected":true,"region":"Banská Bystrica","source_url":"https://www.visitliptov.sk/en/interests/dead-bats-cave-low-tatras/","source_note":"Visit Liptov lists the underground labyrinth as 19,885 m long and 324 m deep; Slovakia Travel gives public GPS N48°55''33\" E19°38''25\"."}',
  '{"length_m":19885,"depth_m":324,"difficulty":"hard","equipment_required":["helmet","lamp","warm clothes","sturdy shoes"],"notable_features":["14 known levels","bat bone finds","Bystrický Dome","alpine cave"],"coordinate_quality":"public_gps_coordinate"}',
  '{"geology":"limestone in the Ďumbier high-mountain karst","source_url":"https://www.visitliptov.sk/en/interests/dead-bats-cave-low-tatras/","source_note":"Visit Liptov lists the underground labyrinth as 19,885 m long and 324 m deep; Slovakia Travel gives public GPS N48°55''33\" E19°38''25\".","sample_data_quality":"public sourced; not a cave registry export"}'
),
(
  'a0000001-0000-0000-0000-000000000028',
  'Zlá diera public-source survey 2026',
  '{"kind":"karst cave","tags":["karst","other_show_cave","unlit","saris"],"protected":true,"region":"Prešov","source_url":"https://slovakia.travel/en/zla-diera-cave","source_note":"Slovakia Travel gives GPS N49°3''12\" E20°56''38\" and describes it as the only accessible cave in north-east Slovakia; trustworthy total length/depth not inserted here."}',
  '{"length_m":null,"depth_m":null,"difficulty":"medium","equipment_required":["helmet","lamp","sturdy shoes","warm clothes"],"notable_features":["unlit guided cave","traditional carbide lamp tours","only accessible cave in Prešov district"],"coordinate_quality":"public_gps_coordinate"}',
  '{"geology":"limestone and dolomite in Bachureň/Branisko area","source_url":"https://slovakia.travel/en/zla-diera-cave","source_note":"Slovakia Travel gives GPS N49°3''12\" E20°56''38\" and describes it as the only accessible cave in north-east Slovakia; trustworthy total length/depth not inserted here.","sample_data_quality":"public sourced; not a cave registry export"}'
),
(
  'a0000001-0000-0000-0000-000000000029',
  'Prepoštská jaskyňa public-source survey 2026',
  '{"kind":"travertine cave / rock shelter","tags":["travertine","archaeology","museum","neanderthal_site"],"protected":true,"region":"Trenčín","source_url":"https://www.ssj.sk/en/clanok/220-prepostska-cave","source_note":"SSJ describes an internal space of about 6 m plus a narrow 8 m passage; Slovakia Travel gives GPS N48°46''40\" E18°35''0\"."}',
  '{"length_m":14,"depth_m":null,"difficulty":"easy","equipment_required":["normal visitor clothing"],"notable_features":["prehistoric museum","rock overhang","important archaeological site"],"coordinate_quality":"public_gps_coordinate"}',
  '{"geology":"travertine formed by mineral spring activity","source_url":"https://www.ssj.sk/en/clanok/220-prepostska-cave","source_note":"SSJ describes an internal space of about 6 m plus a narrow 8 m passage; Slovakia Travel gives GPS N48°46''40\" E18°35''0\".","sample_data_quality":"public sourced; not a cave registry export"}'
),
(
  'a0000001-0000-0000-0000-000000000030',
  'Bojnická hradná jaskyňa public-source survey 2026',
  '{"kind":"travertine cave","tags":["travertine","castle_cave","tourism"],"protected":true,"region":"Trenčín","source_url":"https://slovakia.travel/en/bojnicka-hradna-jaskyna-cave","source_note":"Slovakia Travel gives GPS N48°46''48\" E18°34''40\" and describes a 22 m diameter, 6 m high natural cave 26 m below the fourth courtyard."}',
  '{"length_m":null,"depth_m":null,"difficulty":"easy","equipment_required":["normal visitor clothing"],"notable_features":["circular chamber","diameter about 22 m","height about 6 m","castle well"],"coordinate_quality":"public_gps_coordinate"}',
  '{"geology":"travertine cave below Bojnice Castle","source_url":"https://slovakia.travel/en/bojnicka-hradna-jaskyna-cave","source_note":"Slovakia Travel gives GPS N48°46''48\" E18°34''40\" and describes a 22 m diameter, 6 m high natural cave 26 m below the fourth courtyard.","sample_data_quality":"public sourced; not a cave registry export"}'
),
(
  'a0000001-0000-0000-0000-000000000031',
  'Okno Cave public-source survey 2026',
  '{"kind":"fluvial karst cave","tags":["karst","national_nature_monument","demanovska_valley","archaeology"],"protected":true,"region":"Žilina","source_url":"https://www.ssj.sk/en/clanok/216-okno-cave","source_note":"SSJ gives length 2,570 m, vertical span 110 m and location in the Okno cliff at 915 m elevation. Coordinate is an approximate public map point in the Demänovská Valley, not an official entrance coordinate."}',
  '{"length_m":2570,"depth_m":110,"difficulty":"restricted","equipment_required":["permit required"],"notable_features":["old tourist cave","flowstone fill","bat locality","archaeological finds"],"coordinate_quality":"approximate_public_locality"}',
  '{"geology":"dark Middle Triassic limestone of the Krížna Nappe","source_url":"https://www.ssj.sk/en/clanok/216-okno-cave","source_note":"SSJ gives length 2,570 m, vertical span 110 m and location in the Okno cliff at 915 m elevation. Coordinate is an approximate public map point in the Demänovská Valley, not an official entrance coordinate.","sample_data_quality":"public sourced; not a cave registry export"}'
),
(
  'a0000001-0000-0000-0000-000000000032',
  'Drienovská jaskyňa public-source survey 2026',
  '{"kind":"spring river cave","tags":["karst","national_nature_monument","slovak_karst","bats"],"protected":true,"region":"Košice","source_url":"https://www.ssj.sk/en/clanok/201-drienovska-cave","source_note":"SSJ gives length 1,348 m, vertical span 85 m and location north of Drienovec at the mouth of the Miglinc Valley. Coordinate is approximate public map placement."}',
  '{"length_m":1348,"depth_m":85,"difficulty":"restricted","equipment_required":["permit required"],"notable_features":["underground stream","lakes","cascades","gypsum crusts","important bat locality"],"coordinate_quality":"approximate_public_locality"}',
  '{"geology":"Middle Triassic Wetterstein limestone of the Silica Nappe","source_url":"https://www.ssj.sk/en/clanok/201-drienovska-cave","source_note":"SSJ gives length 1,348 m, vertical span 85 m and location north of Drienovec at the mouth of the Miglinc Valley. Coordinate is approximate public map placement.","sample_data_quality":"public sourced; not a cave registry export"}'
),
(
  'a0000001-0000-0000-0000-000000000033',
  'Jaskyňa Zlomísk public-source survey 2026',
  '{"kind":"large karst cave system","tags":["karst","national_nature_monument","janska_valley","low_tatras"],"protected":true,"region":"Žilina","source_url":"https://www.ssj.sk/en/clanok/207-zlomisk-cave","source_note":"SSJ gives length 10,688 m, vertical span 147 m and location in the central karst of Jánska Valley. Coordinate is approximate public map placement."}',
  '{"length_m":10688,"depth_m":147,"difficulty":"restricted","equipment_required":["permit required","technical caving gear"],"notable_features":["large cave system","two known entrances","horizontal passages","vertical connections"],"coordinate_quality":"approximate_public_locality"}',
  '{"geology":"Middle Triassic Gutenstein limestone of the Choč Nappe","source_url":"https://www.ssj.sk/en/clanok/207-zlomisk-cave","source_note":"SSJ gives length 10,688 m, vertical span 147 m and location in the central karst of Jánska Valley. Coordinate is approximate public map placement.","sample_data_quality":"public sourced; not a cave registry export"}'
),
(
  'a0000001-0000-0000-0000-000000000034',
  'Hrušovská jaskyňa public-source survey 2026',
  '{"kind":"spring cave","tags":["karst","slovak_karst","world_heritage","spring_cave"],"protected":true,"region":"Košice","source_url":"https://www.ssj.sk/en/clanok/186-natural-world-heritage-the-slovak-karst","source_note":"SSJ''s Slovak Karst world-heritage overview gives length 780 m and location close to Hrušov on the eastern foothill of the Silická Plateau. Coordinate is approximate public map placement."}',
  '{"length_m":780,"depth_m":null,"difficulty":"restricted","equipment_required":["permit required"],"notable_features":["underground stream","helictites","calcite crystals","flowstone shield"],"coordinate_quality":"approximate_public_locality"}',
  '{"geology":"limestone cave on the eastern foothill of the Silická Plateau","source_url":"https://www.ssj.sk/en/clanok/186-natural-world-heritage-the-slovak-karst","source_note":"SSJ''s Slovak Karst world-heritage overview gives length 780 m and location close to Hrušov on the eastern foothill of the Silická Plateau. Coordinate is approximate public map placement.","sample_data_quality":"public sourced; not a cave registry export"}'
),
(
  'a0000001-0000-0000-0000-000000000035',
  'Skalistý potok Cave public-source survey 2026',
  '{"kind":"spring river cave","tags":["karst","slovak_karst","world_heritage","siphons","speleodiving"],"protected":true,"region":"Košice","source_url":"https://www.ssj.sk/en/clanok/186-natural-world-heritage-the-slovak-karst","source_note":"SSJ''s Slovak Karst overview gives length 5,855 m and vertical distance 317 m near Háj. Coordinate is approximate public map placement."}',
  '{"length_m":5855,"depth_m":317,"difficulty":"technical","equipment_required":["permit required","technical caving gear","diving equipment in siphon sections"],"notable_features":["underground stream","siphons","lakes","rapids","waterfalls"],"coordinate_quality":"approximate_public_locality"}',
  '{"geology":"karst cave at the southern foothill of the Jasovská Plateau","source_url":"https://www.ssj.sk/en/clanok/186-natural-world-heritage-the-slovak-karst","source_note":"SSJ''s Slovak Karst overview gives length 5,855 m and vertical distance 317 m near Háj. Coordinate is approximate public map placement.","sample_data_quality":"public sourced; not a cave registry export"}'
),
(
  'a0000001-0000-0000-0000-000000000036',
  'Kunia priepasť public-source survey 2026',
  '{"kind":"abyss cave","tags":["abyss","karst","slovak_karst","vertical"],"protected":true,"region":"Košice","source_url":"https://www.ssj.sk/en/clanok/186-natural-world-heritage-the-slovak-karst","source_note":"SSJ gives length 813 m and depth 203 m for Kunia Abyss on the southern edge of the Jasovská Plateau. Coordinate is approximate public map placement."}',
  '{"length_m":813,"depth_m":203,"difficulty":"technical","equipment_required":["permit required","vertical caving gear"],"notable_features":["cascading shafts","horizontal passages","flowstone fills","possible hydrological link to Skalistý potok"],"coordinate_quality":"approximate_public_locality"}',
  '{"geology":"karst abyss on the southern edge of the Jasovská Plateau","source_url":"https://www.ssj.sk/en/clanok/186-natural-world-heritage-the-slovak-karst","source_note":"SSJ gives length 813 m and depth 203 m for Kunia Abyss on the southern edge of the Jasovská Plateau. Coordinate is approximate public map placement.","sample_data_quality":"public sourced; not a cave registry export"}'
),
(
  'a0000001-0000-0000-0000-000000000037',
  'Diviačia priepasť public-source survey 2026',
  '{"kind":"abyss cave","tags":["abyss","karst","slovak_karst","vertical"],"protected":true,"region":"Košice","source_url":"https://www.ssj.sk/en/clanok/186-natural-world-heritage-the-slovak-karst","source_note":"SSJ gives depth 123 m and location at the eastern edge of the Plešivská Plateau. Coordinate is approximate public map placement."}',
  '{"length_m":null,"depth_m":123,"difficulty":"technical","equipment_required":["permit required","vertical caving gear"],"notable_features":["corrosion-collapse abyss","flowstone decoration","water lilies and cave pearls"],"coordinate_quality":"approximate_public_locality"}',
  '{"geology":"karst abyss on the eastern edge of the Plešivská Plateau","source_url":"https://www.ssj.sk/en/clanok/186-natural-world-heritage-the-slovak-karst","source_note":"SSJ gives depth 123 m and location at the eastern edge of the Plešivská Plateau. Coordinate is approximate public map placement.","sample_data_quality":"public sourced; not a cave registry export"}'
),
(
  'a0000001-0000-0000-0000-000000000038',
  'Zvonivá jama public-source survey 2026',
  '{"kind":"abyss cave","tags":["abyss","karst","slovak_karst","vertical"],"protected":true,"region":"Košice","source_url":"https://www.ssj.sk/en/clanok/186-natural-world-heritage-the-slovak-karst","source_note":"SSJ gives depth 101 m and adjacent horizontal passages 220 m long in the central Plešivská Plateau. Coordinate is approximate public map placement."}',
  '{"length_m":220,"depth_m":101,"difficulty":"technical","equipment_required":["permit required","vertical caving gear"],"notable_features":["corrosion-collapse abyss","underground dome","pagoda stalagmites"],"coordinate_quality":"approximate_public_locality"}',
  '{"geology":"karst abyss in the central Plešivská Plateau","source_url":"https://www.ssj.sk/en/clanok/186-natural-world-heritage-the-slovak-karst","source_note":"SSJ gives depth 101 m and adjacent horizontal passages 220 m long in the central Plešivská Plateau. Coordinate is approximate public map placement.","sample_data_quality":"public sourced; not a cave registry export"}'
),
(
  'a0000001-0000-0000-0000-000000000039',
  'Obrovská priepasť public-source survey 2026',
  '{"kind":"abyss cave","tags":["abyss","karst","slovak_karst","vertical"],"protected":true,"region":"Košice","source_url":"https://www.ssj.sk/en/clanok/186-natural-world-heritage-the-slovak-karst","source_note":"SSJ describes Obrovská Abyss above Jablonov nad Turnou on the Dolný vrch Plateau and gives shaft depth 100 m. Coordinate is approximate public map placement."}',
  '{"length_m":null,"depth_m":100,"difficulty":"technical","equipment_required":["permit required","vertical caving gear"],"notable_features":["corrosion-collapse shaft","Dolný vrch Plateau"],"coordinate_quality":"approximate_public_locality"}',
  '{"geology":"karst abyss on the Dolný vrch Plateau","source_url":"https://www.ssj.sk/en/clanok/186-natural-world-heritage-the-slovak-karst","source_note":"SSJ describes Obrovská Abyss above Jablonov nad Turnou on the Dolný vrch Plateau and gives shaft depth 100 m. Coordinate is approximate public map placement.","sample_data_quality":"public sourced; not a cave registry export"}'
),
(
  'a0000001-0000-0000-0000-000000000040',
  'Snežná diera public-source survey 2026',
  '{"kind":"ice abyss cave","tags":["abyss","ice","karst","slovak_karst"],"protected":true,"region":"Košice","source_url":"https://www.ssj.sk/en/clanok/186-natural-world-heritage-the-slovak-karst","source_note":"SSJ gives length 100 m and depth 25 m in the Horný vrch Plateau north of the upper Zádielska Gorge. Coordinate is approximate public map placement."}',
  '{"length_m":100,"depth_m":25,"difficulty":"restricted","equipment_required":["permit required"],"notable_features":["permanent ice fill","crevasse-corrosion cave","Horný vrch Plateau"],"coordinate_quality":"approximate_public_locality"}',
  '{"geology":"crevasse-corrosion gravitationally widened fissure","source_url":"https://www.ssj.sk/en/clanok/186-natural-world-heritage-the-slovak-karst","source_note":"SSJ gives length 100 m and depth 25 m in the Horný vrch Plateau north of the upper Zádielska Gorge. Coordinate is approximate public map placement.","sample_data_quality":"public sourced; not a cave registry export"}'
),
(
  'a0000001-0000-0000-0000-000000000041',
  'Jaskyňa v Havranej skale public-source survey 2026',
  '{"kind":"karst cave","tags":["karst","freely_accessible","slovak_paradise"],"protected":true,"region":"Košice","source_url":"https://www.ssj.sk/sk/verejnosti-volne-pristupne-jaskyne","source_note":"SSJ lists Jaskyňa v Havranej skale among caves freely open to the public. GPS is taken from a public hiking/video listing and should be treated as public approximate data."}',
  '{"length_m":null,"depth_m":null,"difficulty":"medium","equipment_required":["lamp","sturdy shoes"],"notable_features":["freely accessible cave","Havrania skala area","hiking route"],"coordinate_quality":"approximate_public_locality"}',
  '{"geology":"karst cave in Slovenský raj / Stratenská hornatina area","source_url":"https://www.ssj.sk/sk/verejnosti-volne-pristupne-jaskyne","source_note":"SSJ lists Jaskyňa v Havranej skale among caves freely open to the public. GPS is taken from a public hiking/video listing and should be treated as public approximate data.","sample_data_quality":"public sourced; not a cave registry export"}'
),
(
  'a0000001-0000-0000-0000-000000000042',
  'Zelená jaskyňa public-source survey 2026',
  '{"kind":"karst cave","tags":["karst","freely_accessible","slovak_paradise"],"protected":true,"region":"Košice","source_url":"https://www.kamnavylet.sk/sk/atrakcia/zelena-jaskyna","source_note":"KamNaVylet gives GPS 48.85918, 20.30981 and describes it as freely accessible; SSJ also lists Zelená jaskyňa among freely open caves."}',
  '{"length_m":null,"depth_m":null,"difficulty":"easy","equipment_required":["lamp","sturdy shoes"],"notable_features":["freely accessible cave","near Dobšinská Ice Cave","spacious chamber"],"coordinate_quality":"public_gps_coordinate"}',
  '{"geology":"karst cave in the Slovak Paradise area","source_url":"https://www.kamnavylet.sk/sk/atrakcia/zelena-jaskyna","source_note":"KamNaVylet gives GPS 48.85918, 20.30981 and describes it as freely accessible; SSJ also lists Zelená jaskyňa among freely open caves.","sample_data_quality":"public sourced; not a cave registry export"}'
),
(
  'a0000001-0000-0000-0000-000000000043',
  'Mažarná public-source survey 2026',
  '{"kind":"karst cave / rock shelter","tags":["karst","freely_accessible","great_fatra","archaeology"],"protected":true,"region":"Žilina","source_url":"https://www.outdooractive.com/en/route/hiking-trail/nagy-fatra/route-to-mazarna-cave/802405254/","source_note":"Outdooractive describes Mažarná as about 130 m long; Wikimedia Commons photo metadata provides public GPS near 48°56''22\"N, 18°57''37\"E."}',
  '{"length_m":130,"depth_m":null,"difficulty":"medium","equipment_required":["lamp","sturdy shoes"],"notable_features":["large cave in Veľká Fatra","Bronze Age finds","cave bear bones"],"coordinate_quality":"public_gps_coordinate"}',
  '{"geology":"karst cave in a limestone cliff of Veľká Fatra","source_url":"https://www.outdooractive.com/en/route/hiking-trail/nagy-fatra/route-to-mazarna-cave/802405254/","source_note":"Outdooractive describes Mažarná as about 130 m long; Wikimedia Commons photo metadata provides public GPS near 48°56''22\"N, 18°57''37\"E.","sample_data_quality":"public sourced; not a cave registry export"}'
),
(
  'a0000001-0000-0000-0000-000000000044',
  'Čertova pec public-source survey 2026',
  '{"kind":"karst cave / archaeological site","tags":["karst","freely_accessible","archaeology","paleolithic"],"protected":true,"region":"Nitra","source_url":"https://en.wikipedia.org/wiki/%C4%8Certova_pec","source_note":"Wikipedia summarizes the cave as 27 m long and near Radošina; SSJ lists Čertova pec among caves freely open to public."}',
  '{"length_m":27,"depth_m":null,"difficulty":"easy","equipment_required":["lamp optional"],"notable_features":["Palaeolithic site","small cave","recreational locality"],"coordinate_quality":"approximate_public_locality"}',
  '{"geology":"small karst cave in Považský Inovec","source_url":"https://en.wikipedia.org/wiki/%C4%8Certova_pec","source_note":"Wikipedia summarizes the cave as 27 m long and near Radošina; SSJ lists Čertova pec among caves freely open to public.","sample_data_quality":"public sourced; not a cave registry export"}'
),
(
  'a0000001-0000-0000-0000-000000000045',
  'Pružinská Dúpna jaskyňa public-source survey 2026',
  '{"kind":"karst cave","tags":["karst","freely_accessible","strážovské_vrchy","archaeology","bats"],"protected":true,"region":"Trenčín","source_url":"https://visit.trencin.sk/pruzinska-dupna-jaskyna/","source_note":"Visit Trenčín gives GPS 49°00''03\"N, 18°30''17\"E; a public hiking photo description states the cave is over 300 m long. SSJ lists it among freely open caves."}',
  '{"length_m":300,"depth_m":null,"difficulty":"medium","equipment_required":["lamp","sturdy shoes"],"notable_features":["one of the oldest known caves in Slovakia","cave lion and cave bear bones","seasonal/guided access"],"coordinate_quality":"public_gps_coordinate"}',
  '{"geology":"karst cave in the Čierny vrch massif above Rečica valley","source_url":"https://visit.trencin.sk/pruzinska-dupna-jaskyna/","source_note":"Visit Trenčín gives GPS 49°00''03\"N, 18°30''17\"E; a public hiking photo description states the cave is over 300 m long. SSJ lists it among freely open caves.","sample_data_quality":"public sourced; not a cave registry export"}'
);

INSERT INTO cave_entrances (cave_id, name, geom, entrance_type, is_public) VALUES
('a0000001-0000-0000-0000-000000000026', 'Tourist entrance', ST_SetSRID(ST_MakePoint(19.674167, 49.008056), 4326), 'tourist', true),
('a0000001-0000-0000-0000-000000000027', 'Guided entrance', ST_SetSRID(ST_MakePoint(19.640278, 48.925833), 4326), 'tourist', true),
('a0000001-0000-0000-0000-000000000028', 'Guided entrance', ST_SetSRID(ST_MakePoint(20.943889, 49.053333), 4326), 'tourist', true),
('a0000001-0000-0000-0000-000000000029', 'Museum entrance', ST_SetSRID(ST_MakePoint(18.583333, 48.777778), 4326), 'tourist', true),
('a0000001-0000-0000-0000-000000000030', 'Castle tour entrance', ST_SetSRID(ST_MakePoint(18.577778, 48.780000), 4326), 'tourist', true),
('a0000001-0000-0000-0000-000000000031', 'Approximate Okno cliff entrance area', ST_SetSRID(ST_MakePoint(19.582900, 49.014800), 4326), 'natural', false),
('a0000001-0000-0000-0000-000000000032', 'Approximate spring entrance area', ST_SetSRID(ST_MakePoint(20.919000, 48.623900), 4326), 'spring', false),
('a0000001-0000-0000-0000-000000000033', 'Approximate main entrance area', ST_SetSRID(ST_MakePoint(19.675500, 49.018000), 4326), 'natural', false),
('a0000001-0000-0000-0000-000000000034', 'Approximate inactive Eveteš spring area', ST_SetSRID(ST_MakePoint(20.635000, 48.589000), 4326), 'spring', false),
('a0000001-0000-0000-0000-000000000035', 'Approximate Skalistý potok spring area', ST_SetSRID(ST_MakePoint(20.857500, 48.626800), 4326), 'spring', false),
('a0000001-0000-0000-0000-000000000036', 'Approximate abyss opening area', ST_SetSRID(ST_MakePoint(20.842500, 48.638000), 4326), 'vertical', false),
('a0000001-0000-0000-0000-000000000037', 'Approximate abyss opening area', ST_SetSRID(ST_MakePoint(20.466000, 48.595000), 4326), 'vertical', false),
('a0000001-0000-0000-0000-000000000038', 'Approximate abyss opening area', ST_SetSRID(ST_MakePoint(20.435000, 48.565000), 4326), 'vertical', false),
('a0000001-0000-0000-0000-000000000039', 'Approximate abyss opening area', ST_SetSRID(ST_MakePoint(20.675000, 48.610000), 4326), 'vertical', false),
('a0000001-0000-0000-0000-000000000040', 'Approximate fissure entrance area', ST_SetSRID(ST_MakePoint(20.816000, 48.623500), 4326), 'vertical', false),
('a0000001-0000-0000-0000-000000000041', 'Public hiking entrance', ST_SetSRID(ST_MakePoint(20.344044, 48.890602), 4326), 'natural', true),
('a0000001-0000-0000-0000-000000000042', 'Public entrance', ST_SetSRID(ST_MakePoint(20.309810, 48.859180), 4326), 'natural', true),
('a0000001-0000-0000-0000-000000000043', 'Public entrance', ST_SetSRID(ST_MakePoint(18.960278, 48.939444), 4326), 'natural', true),
('a0000001-0000-0000-0000-000000000044', 'Public entrance', ST_SetSRID(ST_MakePoint(17.937000, 48.549000), 4326), 'natural', true),
('a0000001-0000-0000-0000-000000000045', 'Public/guided entrance', ST_SetSRID(ST_MakePoint(18.502660, 48.999700), 4326), 'natural', true);

INSERT INTO cave_survey_lines (cave_id, geom, payload) VALUES
(
  'a0000001-0000-0000-0000-000000000026',
  ST_SetSRID(ST_GeomFromText('LINESTRING(19.674167 49.008056, 19.675251 49.008522, 19.675507 49.010423, 19.673546 49.012634)'), 4326),
  '{"passage_name":"schematic public-source demo line","source_note":"Generated schematic line from public/approximate locality coordinate; not an official cave survey.","source_url":"https://www.visitliptov.sk/zaujimavosti/stanisovska-jaskyna-janska-dolina/","coordinate_quality":"public_gps_coordinate","surveyed_by":"sample_data_schematic","year":2026}'
),
(
  'a0000001-0000-0000-0000-000000000027',
  ST_SetSRID(ST_GeomFromText('LINESTRING(19.640278 48.925833, 19.640791 48.926896, 19.639736 48.928499, 19.636806 48.928881)'), 4326),
  '{"passage_name":"schematic public-source demo line","source_note":"Generated schematic line from public/approximate locality coordinate; not an official cave survey.","source_url":"https://www.visitliptov.sk/en/interests/dead-bats-cave-low-tatras/","coordinate_quality":"public_gps_coordinate","surveyed_by":"sample_data_schematic","year":2026}'
),
(
  'a0000001-0000-0000-0000-000000000028',
  ST_SetSRID(ST_GeomFromText('LINESTRING(20.943889 49.053333, 20.943579 49.054471, 20.941732 49.054989, 20.939269 49.053355)'), 4326),
  '{"passage_name":"schematic public-source demo line","source_note":"Generated schematic line from public/approximate locality coordinate; not an official cave survey.","source_url":"https://slovakia.travel/en/zla-diera-cave","coordinate_quality":"public_gps_coordinate","surveyed_by":"sample_data_schematic","year":2026}'
),
(
  'a0000001-0000-0000-0000-000000000029',
  ST_SetSRID(ST_GeomFromText('LINESTRING(18.583333 48.777778, 18.582352 48.778434, 18.580618 48.777613, 18.579832 48.774764)'), 4326),
  '{"passage_name":"schematic public-source demo line","source_note":"Generated schematic line from public/approximate locality coordinate; not an official cave survey.","source_url":"https://www.ssj.sk/en/clanok/220-prepostska-cave","coordinate_quality":"public_gps_coordinate","surveyed_by":"sample_data_schematic","year":2026}'
),
(
  'a0000001-0000-0000-0000-000000000030',
  ST_SetSRID(ST_GeomFromText('LINESTRING(18.577778 48.780000, 18.576607 48.779851, 18.575837 48.778094, 18.577113 48.775428)'), 4326),
  '{"passage_name":"schematic public-source demo line","source_note":"Generated schematic line from public/approximate locality coordinate; not an official cave survey.","source_url":"https://slovakia.travel/en/bojnicka-hradna-jaskyna-cave","coordinate_quality":"public_gps_coordinate","surveyed_by":"sample_data_schematic","year":2026}'
),
(
  'a0000001-0000-0000-0000-000000000031',
  ST_SetSRID(ST_GeomFromText('LINESTRING(19.582900 49.014800, 19.582114 49.013920, 19.582686 49.012088, 19.585398 49.010913)'), 4326),
  '{"passage_name":"schematic public-source demo line","source_note":"Generated schematic line from public/approximate locality coordinate; not an official cave survey.","source_url":"https://www.ssj.sk/en/clanok/216-okno-cave","coordinate_quality":"approximate_public_locality","surveyed_by":"sample_data_schematic","year":2026}'
),
(
  'a0000001-0000-0000-0000-000000000032',
  ST_SetSRID(ST_GeomFromText('LINESTRING(20.919000 48.623900, 20.918984 48.622720, 20.920617 48.621713, 20.923435 48.622605)'), 4326),
  '{"passage_name":"schematic public-source demo line","source_note":"Generated schematic line from public/approximate locality coordinate; not an official cave survey.","source_url":"https://www.ssj.sk/en/clanok/201-drienovska-cave","coordinate_quality":"approximate_public_locality","surveyed_by":"sample_data_schematic","year":2026}'
),
(
  'a0000001-0000-0000-0000-000000000033',
  ST_SetSRID(ST_GeomFromText('LINESTRING(19.675500 49.018000, 19.676262 49.017099, 19.678155 49.017411, 19.679696 49.019933)'), 4326),
  '{"passage_name":"schematic public-source demo line","source_note":"Generated schematic line from public/approximate locality coordinate; not an official cave survey.","source_url":"https://www.ssj.sk/en/clanok/207-zlomisk-cave","coordinate_quality":"approximate_public_locality","surveyed_by":"sample_data_schematic","year":2026}'
),
(
  'a0000001-0000-0000-0000-000000000034',
  ST_SetSRID(ST_GeomFromText('LINESTRING(20.635000 48.589000, 20.636166 48.588820, 20.637391 48.590297, 20.636899 48.593212)'), 4326),
  '{"passage_name":"schematic public-source demo line","source_note":"Generated schematic line from public/approximate locality coordinate; not an official cave survey.","source_url":"https://www.ssj.sk/en/clanok/186-natural-world-heritage-the-slovak-karst","coordinate_quality":"approximate_public_locality","surveyed_by":"sample_data_schematic","year":2026}'
),
(
  'a0000001-0000-0000-0000-000000000035',
  ST_SetSRID(ST_GeomFromText('LINESTRING(20.857500 48.626800, 20.858498 48.627430, 20.858453 48.629347, 20.856170 48.631225)'), 4326),
  '{"passage_name":"schematic public-source demo line","source_note":"Generated schematic line from public/approximate locality coordinate; not an official cave survey.","source_url":"https://www.ssj.sk/en/clanok/186-natural-world-heritage-the-slovak-karst","coordinate_quality":"approximate_public_locality","surveyed_by":"sample_data_schematic","year":2026}'
),
(
  'a0000001-0000-0000-0000-000000000036',
  ST_SetSRID(ST_GeomFromText('LINESTRING(20.842500 48.638000, 20.842840 48.639130, 20.841548 48.640548, 20.838594 48.640467)'), 4326),
  '{"passage_name":"schematic public-source demo line","source_note":"Generated schematic line from public/approximate locality coordinate; not an official cave survey.","source_url":"https://www.ssj.sk/en/clanok/186-natural-world-heritage-the-slovak-karst","coordinate_quality":"approximate_public_locality","surveyed_by":"sample_data_schematic","year":2026}'
),
(
  'a0000001-0000-0000-0000-000000000037',
  ST_SetSRID(ST_GeomFromText('LINESTRING(20.466000 48.595000, 20.465515 48.596076, 20.463610 48.596299, 20.461433 48.594299)'), 4326),
  '{"passage_name":"schematic public-source demo line","source_note":"Generated schematic line from public/approximate locality coordinate; not an official cave survey.","source_url":"https://www.ssj.sk/en/clanok/186-natural-world-heritage-the-slovak-karst","coordinate_quality":"approximate_public_locality","surveyed_by":"sample_data_schematic","year":2026}'
),
(
  'a0000001-0000-0000-0000-000000000038',
  ST_SetSRID(ST_GeomFromText('LINESTRING(20.435000 48.565000, 20.433928 48.565494, 20.432344 48.564412, 20.432013 48.561475)'), 4326),
  '{"passage_name":"schematic public-source demo line","source_note":"Generated schematic line from public/approximate locality coordinate; not an official cave survey.","source_url":"https://www.ssj.sk/en/clanok/186-natural-world-heritage-the-slovak-karst","coordinate_quality":"approximate_public_locality","surveyed_by":"sample_data_schematic","year":2026}'
),
(
  'a0000001-0000-0000-0000-000000000039',
  ST_SetSRID(ST_GeomFromText('LINESTRING(20.675000 48.610000, 20.673867 48.609670, 20.673381 48.607814, 20.675059 48.605380)'), 4326),
  '{"passage_name":"schematic public-source demo line","source_note":"Generated schematic line from public/approximate locality coordinate; not an official cave survey.","source_url":"https://www.ssj.sk/en/clanok/186-natural-world-heritage-the-slovak-karst","coordinate_quality":"approximate_public_locality","surveyed_by":"sample_data_schematic","year":2026}'
),
(
  'a0000001-0000-0000-0000-000000000040',
  ST_SetSRID(ST_GeomFromText('LINESTRING(20.816000 48.623500, 20.815362 48.622508, 20.816213 48.620788, 20.819075 48.620052)'), 4326),
  '{"passage_name":"schematic public-source demo line","source_note":"Generated schematic line from public/approximate locality coordinate; not an official cave survey.","source_url":"https://www.ssj.sk/en/clanok/186-natural-world-heritage-the-slovak-karst","coordinate_quality":"approximate_public_locality","surveyed_by":"sample_data_schematic","year":2026}'
),
(
  'a0000001-0000-0000-0000-000000000041',
  ST_SetSRID(ST_GeomFromText('LINESTRING(20.344044 48.890602, 20.344213 48.889434, 20.345984 48.888695, 20.348627 48.890017)'), 4326),
  '{"passage_name":"schematic public-source demo line","source_note":"Generated schematic line from public/approximate locality coordinate; not an official cave survey.","source_url":"https://www.ssj.sk/sk/verejnosti-volne-pristupne-jaskyne","coordinate_quality":"approximate_public_locality","surveyed_by":"sample_data_schematic","year":2026}'
),
(
  'a0000001-0000-0000-0000-000000000042',
  ST_SetSRID(ST_GeomFromText('LINESTRING(20.309810 48.859180, 20.310704 48.858410, 20.312525 48.859013, 20.313652 48.861745)'), 4326),
  '{"passage_name":"schematic public-source demo line","source_note":"Generated schematic line from public/approximate locality coordinate; not an official cave survey.","source_url":"https://www.kamnavylet.sk/sk/atrakcia/zelena-jaskyna","coordinate_quality":"public_gps_coordinate","surveyed_by":"sample_data_schematic","year":2026}'
),
(
  'a0000001-0000-0000-0000-000000000043',
  ST_SetSRID(ST_GeomFromText('LINESTRING(18.960278 48.939444, 18.961458 48.939449, 18.962436 48.941099, 18.961495 48.943901)'), 4326),
  '{"passage_name":"schematic public-source demo line","source_note":"Generated schematic line from public/approximate locality coordinate; not an official cave survey.","source_url":"https://www.outdooractive.com/en/route/hiking-trail/nagy-fatra/route-to-mazarna-cave/802405254/","coordinate_quality":"public_gps_coordinate","surveyed_by":"sample_data_schematic","year":2026}'
),
(
  'a0000001-0000-0000-0000-000000000044',
  ST_SetSRID(ST_GeomFromText('LINESTRING(17.937000 48.549000, 17.937887 48.549778, 17.937543 48.551665, 17.934995 48.553162)'), 4326),
  '{"passage_name":"schematic public-source demo line","source_note":"Generated schematic line from public/approximate locality coordinate; not an official cave survey.","source_url":"https://en.wikipedia.org/wiki/%C4%8Certova_pec","coordinate_quality":"approximate_public_locality","surveyed_by":"sample_data_schematic","year":2026}'
),
(
  'a0000001-0000-0000-0000-000000000045',
  ST_SetSRID(ST_GeomFromText('LINESTRING(18.502660 48.999700, 18.502819 49.000869, 18.501321 49.002068, 18.498416 49.001525)'), 4326),
  '{"passage_name":"schematic public-source demo line","source_note":"Generated schematic line from public/approximate locality coordinate; not an official cave survey.","source_url":"https://visit.trencin.sk/pruzinska-dupna-jaskyna/","coordinate_quality":"public_gps_coordinate","surveyed_by":"sample_data_schematic","year":2026}'
);
