-- Seed data for common beneficial fungi

-- Mycorrhizal fungi
INSERT INTO fungi (scientific_name, common_name, fungal_type, mycorrhizal_subtype, cultivation_substrate, fruiting_season, edible, medicinal_properties, hardiness_zone_min, hardiness_zone_max) VALUES
('Laccaria bicolor', 'Bicolored Deceiver', 'mycorrhizal', 'ecto', ARRAY['forest soil', 'tree roots'], 'summer-fall', true, ARRAY[]::text[], 3, 9),
('Pisolithus tinctorius', 'Dye-maker''s Puffball', 'mycorrhizal', 'ecto', ARRAY['acidic soil', 'tree roots'], 'summer-fall', false, ARRAY[]::text[], 5, 10),
('Rhizopogon spp.', 'False Truffle', 'mycorrhizal', 'ecto', ARRAY['conifer roots'], 'year-round', false, ARRAY[]::text[], 3, 8);

-- Edible saprotrophic mushrooms
INSERT INTO fungi (scientific_name, common_name, fungal_type, mycorrhizal_subtype, cultivation_substrate, fruiting_season, edible, medicinal_properties, hardiness_zone_min, hardiness_zone_max) VALUES
('Pleurotus ostreatus', 'Oyster Mushroom', 'saprotrophic', NULL, ARRAY['hardwood logs', 'straw', 'coffee grounds'], 'spring-fall', true, ARRAY['immune support', 'cholesterol reduction'], 3, 10),
('Lentinula edodes', 'Shiitake', 'saprotrophic', NULL, ARRAY['oak logs', 'hardwood sawdust'], 'spring-fall', true, ARRAY['immune support', 'antiviral'], 5, 9),
('Grifola frondosa', 'Maitake', 'saprotrophic', NULL, ARRAY['hardwood logs', 'oak stumps'], 'fall', true, ARRAY['immune support', 'blood sugar regulation'], 4, 8),
('Hericium erinaceus', 'Lion''s Mane', 'saprotrophic', NULL, ARRAY['hardwood logs', 'supplemented sawdust'], 'fall', true, ARRAY['cognitive support', 'nerve regeneration'], 4, 8),
('Agrocybe aegerita', 'Pioppino', 'saprotrophic', NULL, ARRAY['hardwood logs', 'straw', 'poplar'], 'spring-fall', true, ARRAY[]::text[], 6, 10);

-- Medicinal mushrooms
INSERT INTO fungi (scientific_name, common_name, fungal_type, mycorrhizal_subtype, cultivation_substrate, fruiting_season, edible, medicinal_properties, hardiness_zone_min, hardiness_zone_max) VALUES
('Ganoderma lucidum', 'Reishi', 'saprotrophic', NULL, ARRAY['hardwood logs', 'supplemented sawdust'], 'summer-fall', false, ARRAY['immune modulation', 'stress relief', 'liver support'], 4, 9),
('Trametes versicolor', 'Turkey Tail', 'saprotrophic', NULL, ARRAY['hardwood logs', 'stumps'], 'year-round', false, ARRAY['immune support', 'cancer adjunct therapy'], 3, 10),
('Cordyceps militaris', 'Cordyceps', 'parasitic', NULL, ARRAY['grain substrate', 'rice'], 'cultivated year-round', true, ARRAY['energy enhancement', 'athletic performance'], 5, 9);

-- Plant-fungi associations
INSERT INTO plant_fungi (plant_id, fungi_id, association_strength)
SELECT p.id, f.id, 'beneficial'
FROM plants p, fungi f
WHERE p.mycorrhizal_type = 'ecto' AND f.mycorrhizal_subtype = 'ecto';

INSERT INTO plant_fungi (plant_id, fungi_id, association_strength)
SELECT p.id, f.id, 'beneficial'
FROM plants p, fungi f
WHERE p.mycorrhizal_type = 'endo' AND f.fungal_type = 'mycorrhizal' AND f.mycorrhizal_subtype IS NULL;
