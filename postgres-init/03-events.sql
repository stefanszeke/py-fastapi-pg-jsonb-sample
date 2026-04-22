\connect cavesdb

INSERT INTO caves (id, name, lon, lat, type, depth_m, region) VALUES
(1, 'Domica',             20.463, 48.359, 'Karst cave',                 25, 'Slovak Karst'),
(2, 'Jasovská jaskyňa',   20.906, 48.631, 'Limestone cave',             22, 'Košice'),
(3, 'Važecká jaskyňa',    19.991, 49.042, 'Crystalline limestone cave', 30, 'Liptov'),
(4, 'Silická Ľadnica',    20.536, 48.554, 'Ice cave',                   45, 'Slovak Karst'),
(5, 'Harmanecká jaskyňa', 19.064, 48.847, 'Limestone cave',             35, 'Banská Bystrica');

INSERT INTO events (cave_id, name, public_payload, caver_payload, scientific_payload) VALUES
(
  1, 'Domica Cave',
  '{"kind":"cave","region":"Slovak Karst","tags":["karst","UNESCO","tourism"],"protected":true}',
  '{"length_m":5358,"difficulty":"easy","entrance_gps":[48.359,20.463],"equipment_required":["lamp"]}',
  '{"geology":"limestone karst","discovered":1926,"species_count":34,"drainage_basin":"Styx river","secret":"domica-research-2024"}'
),
(
  2, 'Jasovská Cave',
  '{"kind":"cave","region":"Košice","tags":["karst","tourism","historical"],"protected":true}',
  '{"length_m":2811,"difficulty":"easy","entrance_gps":[48.631,20.906],"equipment_required":["lamp","jacket"]}',
  '{"geology":"triassic limestone","discovered":1846,"species_count":21,"bat_colonies":3,"secret":"jasovska-bio-survey"}'
),
(
  3, 'Važecká Cave',
  '{"kind":"cave","region":"Liptov","tags":["karst","paleontology"],"protected":true}',
  '{"length_m":850,"difficulty":"medium","entrance_gps":[49.042,19.991],"equipment_required":["helmet","lamp","jacket"]}',
  '{"geology":"crystalline limestone","discovered":1922,"species_count":8,"fossil_finds":["cave bear","mammoth"],"secret":"vazecka-fossil-log"}'
),
(
  4, 'Silická Ľadnica',
  '{"kind":"cave","region":"Slovak Karst","tags":["ice-cave","karst","rare"],"protected":true}',
  '{"length_m":1107,"difficulty":"hard","entrance_gps":[48.554,20.536],"equipment_required":["helmet","lamp","crampons","rope"]}',
  '{"geology":"limestone with permafrost","discovered":1931,"species_count":5,"avg_temp_c":-4,"ice_volume_m3":12000,"secret":"silicka-climate-data"}'
),
(
  5, 'Harmanecká Cave',
  '{"kind":"cave","region":"Banská Bystrica","tags":["karst","bats","tourism"],"protected":false}',
  '{"length_m":2900,"difficulty":"medium","entrance_gps":[48.847,19.064],"equipment_required":["helmet","lamp"]}',
  '{"geology":"mesozoic limestone","discovered":1932,"species_count":18,"bat_colonies":7,"drip_rate_ml_hr":450,"secret":"harmanec-bat-census"}'
);
