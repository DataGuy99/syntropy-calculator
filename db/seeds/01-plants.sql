-- Seed data with common permaculture plants

-- Trees (Canopy layer)
INSERT INTO plants (scientific_name, common_names, plant_family, hardiness_zone_min, hardiness_zone_max, growth_habit, mature_height_cm, mature_width_cm, stratification_layer, succession_stage, lifespan_years, time_to_maturity_years, sun_requirements, soil_ph_min, soil_ph_max, soil_drainage, water_needs, nitrogen_fixer, edible_parts, pollinator_attractant, mycorrhizal_type, wildlife_value) VALUES
('Malus domestica', ARRAY['Apple', 'Common Apple'], 'Rosaceae', 3, 8, 'tree', 600, 500, 'canopy', 'secondary', 50, 5, 'full', 6.0, 7.0, 'well-drained', 'medium', false, ARRAY['fruit', 'flowers'], true, 'ecto', 8),
('Prunus persica', ARRAY['Peach'], 'Rosaceae', 5, 9, 'tree', 500, 400, 'canopy', 'secondary', 25, 3, 'full', 6.0, 7.5, 'well-drained', 'medium', false, ARRAY['fruit'], true, 'ecto', 7),
('Juglans nigra', ARRAY['Black Walnut'], 'Juglandaceae', 4, 9, 'tree', 3000, 2000, 'emergent', 'climax', 150, 10, 'full', 6.0, 7.5, 'well-drained', 'medium', false, ARRAY['nuts'], false, 'ecto', 9),
('Robinia pseudoacacia', ARRAY['Black Locust'], 'Fabaceae', 4, 9, 'tree', 2500, 1500, 'emergent', 'pioneer', 80, 5, 'full', 5.0, 8.0, 'any', 'low', true, ARRAY['flowers'], true, 'endo', 8);

-- Sub-canopy fruit trees
INSERT INTO plants (scientific_name, common_names, plant_family, hardiness_zone_min, hardiness_zone_max, growth_habit, mature_height_cm, mature_width_cm, stratification_layer, succession_stage, lifespan_years, time_to_maturity_years, sun_requirements, soil_ph_min, soil_ph_max, soil_drainage, water_needs, nitrogen_fixer, edible_parts, pollinator_attractant, mycorrhizal_type, wildlife_value) VALUES
('Prunus avium', ARRAY['Cherry', 'Sweet Cherry'], 'Rosaceae', 5, 8, 'tree', 800, 600, 'sub-canopy', 'secondary', 40, 4, 'full', 6.0, 7.5, 'well-drained', 'medium', false, ARRAY['fruit'], true, 'ecto', 9),
('Ficus carica', ARRAY['Fig', 'Common Fig'], 'Moraceae', 7, 10, 'tree', 400, 400, 'sub-canopy', 'secondary', 50, 2, 'full', 6.0, 8.0, 'well-drained', 'low', false, ARRAY['fruit'], false, 'endo', 7);

-- Shrubs (Shrub layer)
INSERT INTO plants (scientific_name, common_names, plant_family, hardiness_zone_min, hardiness_zone_max, growth_habit, mature_height_cm, mature_width_cm, stratification_layer, succession_stage, lifespan_years, time_to_maturity_years, sun_requirements, soil_ph_min, soil_ph_max, soil_drainage, water_needs, nitrogen_fixer, edible_parts, pollinator_attractant, mycorrhizal_type, wildlife_value) VALUES
('Vaccinium corymbosum', ARRAY['Blueberry', 'Highbush Blueberry'], 'Ericaceae', 3, 7, 'shrub', 200, 150, 'shrub', 'secondary', 30, 2, 'full', 4.5, 5.5, 'moist', 'medium', false, ARRAY['fruit'], true, 'ecto', 8),
('Rubus idaeus', ARRAY['Raspberry', 'Red Raspberry'], 'Rosaceae', 3, 9, 'shrub', 150, 100, 'shrub', 'pioneer', 15, 1, 'partial', 5.5, 6.5, 'well-drained', 'medium', false, ARRAY['fruit'], true, 'endo', 7),
('Sambucus nigra', ARRAY['Elderberry', 'Black Elderberry'], 'Adoxaceae', 4, 8, 'shrub', 400, 300, 'shrub', 'pioneer', 25, 2, 'full', 5.5, 6.5, 'moist', 'medium', false, ARRAY['fruit', 'flowers'], true, 'endo', 9),
('Elaeagnus umbellata', ARRAY['Autumn Olive'], 'Elaeagnaceae', 3, 8, 'shrub', 500, 400, 'shrub', 'pioneer', 50, 3, 'full', 5.0, 7.5, 'any', 'low', true, ARRAY['fruit'], true, 'endo', 8);

-- Nitrogen fixers
INSERT INTO plants (scientific_name, common_names, plant_family, hardiness_zone_min, hardiness_zone_max, growth_habit, mature_height_cm, mature_width_cm, stratification_layer, succession_stage, lifespan_years, time_to_maturity_years, sun_requirements, soil_ph_min, soil_ph_max, soil_drainage, water_needs, nitrogen_fixer, dynamic_accumulator, pollinator_attractant, mycorrhizal_type, wildlife_value) VALUES
('Trifolium pratense', ARRAY['Red Clover'], 'Fabaceae', 3, 9, 'herb', 40, 30, 'ground', 'pioneer', 3, 0, 'full', 6.0, 7.0, 'well-drained', 'medium', true, ARRAY['nitrogen', 'phosphorus'], true, 'endo', 6),
('Trifolium repens', ARRAY['White Clover', 'Dutch Clover'], 'Fabaceae', 3, 10, 'groundcover', 15, 50, 'ground', 'pioneer', 5, 0, 'partial', 5.5, 7.0, 'any', 'medium', true, ARRAY['nitrogen'], true, 'endo', 7),
('Vicia sativa', ARRAY['Vetch', 'Common Vetch'], 'Fabaceae', 3, 9, 'vine', 100, 50, 'vertical', 'pioneer', 1, 0, 'full', 6.0, 7.0, 'well-drained', 'low', true, ARRAY['nitrogen'], true, 'endo', 5);

-- Dynamic accumulators
INSERT INTO plants (scientific_name, common_names, plant_family, hardiness_zone_min, hardiness_zone_max, growth_habit, mature_height_cm, mature_width_cm, stratification_layer, succession_stage, lifespan_years, time_to_maturity_years, sun_requirements, soil_ph_min, soil_ph_max, soil_drainage, water_needs, nitrogen_fixer, dynamic_accumulator, edible_parts, medicinal_uses, pollinator_attractant, mycorrhizal_type, wildlife_value) VALUES
('Symphytum officinale', ARRAY['Comfrey'], 'Boraginaceae', 3, 9, 'herb', 100, 60, 'herbaceous', 'pioneer', 20, 1, 'partial', 6.0, 7.0, 'moist', 'medium', false, ARRAY['nitrogen', 'phosphorus', 'potassium', 'calcium'], ARRAY['leaves'], ARRAY['topical wound healing'], true, 'endo', 6),
('Taraxacum officinale', ARRAY['Dandelion'], 'Asteraceae', 3, 9, 'herb', 30, 20, 'ground', 'pioneer', 10, 0, 'any', 5.0, 8.0, 'any', 'low', false, ARRAY['potassium', 'calcium', 'iron'], ARRAY['leaves', 'roots', 'flowers'], ARRAY['liver support', 'digestive aid'], true, 'endo', 7);

-- Culinary herbs
INSERT INTO plants (scientific_name, common_names, plant_family, hardiness_zone_min, hardiness_zone_max, growth_habit, mature_height_cm, mature_width_cm, stratification_layer, succession_stage, lifespan_years, time_to_maturity_years, sun_requirements, soil_ph_min, soil_ph_max, soil_drainage, water_needs, edible_parts, medicinal_uses, pollinator_attractant, mycorrhizal_type, wildlife_value) VALUES
('Rosmarinus officinalis', ARRAY['Rosemary'], 'Lamiaceae', 7, 10, 'shrub', 120, 90, 'herbaceous', 'climax', 20, 1, 'full', 6.0, 7.5, 'well-drained', 'low', ARRAY['leaves'], ARRAY['memory enhancement', 'antioxidant'], true, 'endo', 6),
('Thymus vulgaris', ARRAY['Thyme', 'Common Thyme'], 'Lamiaceae', 5, 9, 'groundcover', 30, 40, 'ground', 'climax', 10, 1, 'full', 6.0, 8.0, 'well-drained', 'low', ARRAY['leaves'], ARRAY['antimicrobial', 'respiratory'], true, 'endo', 7),
('Allium schoenoprasum', ARRAY['Chives'], 'Amaryllidaceae', 3, 9, 'herb', 30, 20, 'herbaceous', 'pioneer', 10, 0, 'full', 6.0, 7.0, 'well-drained', 'medium', ARRAY['leaves', 'flowers'], ARRAY['digestive aid'], true, 'endo', 5),
('Mentha spicata', ARRAY['Spearmint'], 'Lamiaceae', 4, 9, 'herb', 60, 90, 'herbaceous', 'pioneer', 10, 0, 'partial', 6.0, 7.5, 'moist', 'medium', ARRAY['leaves'], ARRAY['digestive aid', 'calming'], true, 'endo', 6);

-- Vegetables
INSERT INTO plants (scientific_name, common_names, plant_family, hardiness_zone_min, hardiness_zone_max, growth_habit, mature_height_cm, mature_width_cm, stratification_layer, succession_stage, lifespan_years, time_to_maturity_years, sun_requirements, soil_ph_min, soil_ph_max, soil_drainage, water_needs, edible_parts, pollinator_attractant, mycorrhizal_type, wildlife_value) VALUES
('Solanum lycopersicum', ARRAY['Tomato'], 'Solanaceae', 9, 11, 'vine', 200, 60, 'vertical', 'pioneer', 1, 0, 'full', 6.0, 6.8, 'well-drained', 'medium', ARRAY['fruit'], true, 'endo', 4),
('Cucurbita pepo', ARRAY['Zucchini', 'Summer Squash'], 'Cucurbitaceae', 3, 10, 'vine', 60, 120, 'ground', 'pioneer', 1, 0, 'full', 6.0, 7.5, 'well-drained', 'high', ARRAY['fruit', 'flowers'], true, 'endo', 5),
('Lactuca sativa', ARRAY['Lettuce'], 'Asteraceae', 4, 9, 'herb', 30, 30, 'herbaceous', 'pioneer', 1, 0, 'partial', 6.0, 7.0, 'moist', 'medium', ARRAY['leaves'], false, 'endo', 3);

-- Companion relationships (beneficial)
INSERT INTO plant_companions (plant_id, companion_id, relationship_type, notes) VALUES
(1, 8, 'beneficial', 'Chives repel aphids from apple trees'),
(1, 17, 'beneficial', 'White clover provides nitrogen and living mulch'),
(2, 8, 'beneficial', 'Chives improve peach tree health'),
(7, 17, 'beneficial', 'White clover ground cover for blueberries'),
(20, 19, 'beneficial', 'Tomato and basil classic companion planting'),
(21, 17, 'beneficial', 'White clover attracts pollinators for squash');

-- Antagonistic relationships
INSERT INTO plant_companions (plant_id, companion_id, relationship_type, notes) VALUES
(3, 1, 'antagonistic', 'Black walnut juglone toxic to many fruit trees'),
(3, 2, 'antagonistic', 'Black walnut juglone toxic to stone fruits'),
(3, 20, 'antagonistic', 'Black walnut toxic to tomatoes');
