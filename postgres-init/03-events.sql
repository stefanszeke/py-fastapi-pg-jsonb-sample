\connect cavesdb

INSERT INTO events (name, public_payload, caver_payload, scientific_payload) VALUES
(
  'Domica Cave',
  '{"kind":"cave","region":"Slovakia","tags":["karst","UNESCO","tourism"],"protected":true}',
  '{"length_m":5358,"difficulty":"easy","entrance_gps":[48.359,20.463],"equipment_required":["lamp"]}',
  '{"geology":"limestone karst","discovered":1926,"species_count":34,"drainage_basin":"Styx river","secret":"domica-research-2024"}'
),
(
  'Jasovská Cave',
  '{"kind":"cave","region":"Slovakia","tags":["karst","tourism","historical"],"protected":true}',
  '{"length_m":2811,"difficulty":"easy","entrance_gps":[48.631,20.906],"equipment_required":["lamp","jacket"]}',
  '{"geology":"triassic limestone","discovered":1846,"species_count":21,"bat_colonies":3,"secret":"jasovska-bio-survey"}'
),
(
  'Važecká Cave',
  '{"kind":"cave","region":"Slovakia","tags":["karst","paleontology"],"protected":true}',
  '{"length_m":850,"difficulty":"medium","entrance_gps":[49.042,19.991],"equipment_required":["helmet","lamp","jacket"]}',
  '{"geology":"crystalline limestone","discovered":1922,"species_count":8,"fossil_finds":["cave bear","mammoth"],"secret":"vazecka-fossil-log"}'
),
(
  'Silická Ľadnica',
  '{"kind":"cave","region":"Slovakia","tags":["ice-cave","karst","rare"],"protected":true}',
  '{"length_m":1107,"difficulty":"hard","entrance_gps":[48.554,20.536],"equipment_required":["helmet","lamp","crampons","rope"]}',
  '{"geology":"limestone with permafrost","discovered":1931,"species_count":5,"avg_temp_c":-4,"ice_volume_m3":12000,"secret":"silicka-climate-data"}'
),
(
  'Harmanecká Cave',
  '{"kind":"cave","region":"Slovakia","tags":["karst","bats","tourism"],"protected":false}',
  '{"length_m":2900,"difficulty":"medium","entrance_gps":[48.847,19.064],"equipment_required":["helmet","lamp"]}',
  '{"geology":"mesozoic limestone","discovered":1932,"species_count":18,"bat_colonies":7,"drip_rate_ml_hr":450,"secret":"harmanec-bat-census"}'
);
