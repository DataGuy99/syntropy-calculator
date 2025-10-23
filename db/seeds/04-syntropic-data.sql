-- Comprehensive Syntropic Agroforestry Data
-- Based on Ernst Götsch methodology and permaculture principles

-- Update existing plants with syntropic characteristics

-- NITROGEN FIXERS (Critical for syntropic systems)
UPDATE plants SET
    pruning_strategy = 'chop-and-drop',
    pruning_frequency_months = 3,
    biomass_production = 'very-high',
    shade_tolerance = 'shade-intolerant',
    root_depth = 'deep',
    root_type = 'taproot',
    canopy_density = 'medium',
    leaf_litter_quality = 'excellent',
    regenerates_from_cutting = true
WHERE scientific_name = 'Trifolium pratense';

UPDATE plants SET
    pruning_strategy = 'chop-and-drop',
    pruning_frequency_months = 2,
    biomass_production = 'high',
    shade_tolerance = 'partial-shade',
    root_depth = 'shallow',
    root_type = 'fibrous',
    canopy_density = 'dense',
    leaf_litter_quality = 'excellent',
    regenerates_from_cutting = true
WHERE scientific_name = 'Trifolium repens';

UPDATE plants SET
    pruning_strategy = 'chop-and-drop',
    pruning_frequency_months = 4,
    biomass_production = 'very-high',
    shade_tolerance = 'shade-intolerant',
    root_depth = 'very-deep',
    root_type = 'taproot',
    canopy_density = 'open',
    leaf_litter_quality = 'excellent',
    co2_sequestration_kg_per_year = 500,
    frost_tolerance_celsius = -15,
    wind_tolerance = 'excellent',
    regenerates_from_cutting = true
WHERE scientific_name = 'Robinia pseudoacacia';

UPDATE plants SET
    pruning_strategy = 'chop-and-drop',
    biomass_production = 'high',
    shade_tolerance = 'partial-shade',
    root_depth = 'medium',
    root_type = 'fibrous',
    canopy_density = 'medium',
    leaf_litter_quality = 'good',
    regenerates_from_cutting = true
WHERE scientific_name = 'Vicia sativa';

-- FRUIT TREES
UPDATE plants SET
    pruning_strategy = 'minimal',
    pruning_frequency_months = 12,
    biomass_production = 'medium',
    shade_tolerance = 'shade-intolerant',
    root_depth = 'deep',
    root_type = 'taproot',
    canopy_density = 'dense',
    leaf_litter_quality = 'good',
    co2_sequestration_kg_per_year = 200,
    frost_tolerance_celsius = -20,
    wind_tolerance = 'good',
    drought_deciduous = true,
    seed_viability_years = 2
WHERE scientific_name = 'Malus domestica';

UPDATE plants SET
    pruning_strategy = 'minimal',
    pruning_frequency_months = 12,
    biomass_production = 'medium',
    shade_tolerance = 'shade-intolerant',
    root_depth = 'deep',
    root_type = 'taproot',
    canopy_density = 'medium',
    leaf_litter_quality = 'good',
    co2_sequestration_kg_per_year = 180,
    frost_tolerance_celsius = -15,
    wind_tolerance = 'fair'
WHERE scientific_name = 'Prunus persica';

-- WALNUT (Allelopathic - important for syntropic design)
UPDATE plants SET
    pruning_strategy = 'minimal',
    pruning_frequency_months = 24,
    biomass_production = 'high',
    shade_tolerance = 'shade-intolerant',
    root_depth = 'very-deep',
    root_type = 'taproot',
    allelopathic = true,
    allelopathic_effect = 'Juglone production inhibits many plants (tomatoes, apples, potatoes). Plant only with tolerant species.',
    canopy_density = 'very-dense',
    leaf_litter_quality = 'poor',
    co2_sequestration_kg_per_year = 800,
    frost_tolerance_celsius = -30,
    wind_tolerance = 'excellent'
WHERE scientific_name = 'Juglans nigra';

-- DYNAMIC ACCUMULATORS
UPDATE plants SET
    pruning_strategy = 'chop-and-drop',
    pruning_frequency_months = 3,
    biomass_production = 'very-high',
    shade_tolerance = 'partial-shade',
    root_depth = 'very-deep',
    root_type = 'taproot',
    canopy_density = 'medium',
    leaf_litter_quality = 'excellent',
    regenerates_from_cutting = true,
    frost_tolerance_celsius = -10,
    wind_tolerance = 'good'
WHERE scientific_name = 'Symphytum officinale';

UPDATE plants SET
    pruning_strategy = 'none',
    biomass_production = 'medium',
    shade_tolerance = 'partial-shade',
    root_depth = 'deep',
    root_type = 'taproot',
    canopy_density = 'open',
    leaf_litter_quality = 'excellent',
    frost_tolerance_celsius = -30,
    wind_tolerance = 'excellent'
WHERE scientific_name = 'Taraxacum officinale';

-- Detailed nutrient accumulation data
INSERT INTO nutrient_accumulation (plant_id, nutrient, concentration_level, accumulation_location, release_rate, cycling_notes) VALUES
((SELECT id FROM plants WHERE scientific_name = 'Symphytum officinale'), 'nitrogen', 'high', 'leaves', 'fast', 'Breaks down rapidly, excellent green manure'),
((SELECT id FROM plants WHERE scientific_name = 'Symphytum officinale'), 'phosphorus', 'very-high', 'leaves', 'medium', 'Deep roots mine subsoil phosphorus'),
((SELECT id FROM plants WHERE scientific_name = 'Symphytum officinale'), 'potassium', 'very-high', 'leaves', 'fast', 'Potassium readily available from leaf mulch'),
((SELECT id FROM plants WHERE scientific_name = 'Symphytum officinale'), 'calcium', 'high', 'whole-plant', 'medium', 'Accumulates from deep soil layers'),
((SELECT id FROM plants WHERE scientific_name = 'Taraxacum officinale'), 'potassium', 'high', 'leaves', 'fast', 'Deep taproot brings up nutrients'),
((SELECT id FROM plants WHERE scientific_name = 'Taraxacum officinale'), 'calcium', 'high', 'roots', 'medium', 'Stores in taproot'),
((SELECT id FROM plants WHERE scientific_name = 'Taraxacum officinale'), 'iron', 'medium', 'leaves', 'fast', 'Bioavailable iron in leaves'),
((SELECT id FROM plants WHERE scientific_name = 'Trifolium pratense'), 'nitrogen', 'very-high', 'roots', 'fast', 'Rhizobia nodules fix atmospheric nitrogen'),
((SELECT id FROM plants WHERE scientific_name = 'Trifolium repens'), 'nitrogen', 'very-high', 'roots', 'fast', 'Continuous nitrogen fixation'),
((SELECT id FROM plants WHERE scientific_name = 'Robinia pseudoacacia'), 'nitrogen', 'very-high', 'roots', 'medium', 'Large-scale nitrogen fixation for reforestation');

-- Pruning schedules for chop-and-drop management
INSERT INTO pruning_schedules (plant_id, pruning_type, frequency_months, season, percentage_to_prune, purpose, biomass_disposal) VALUES
((SELECT id FROM plants WHERE scientific_name = 'Symphytum officinale'), 'chop-and-drop', 2, 'spring-fall', 80, 'Nutrient cycling and mulch production', 'chop-and-drop'),
((SELECT id FROM plants WHERE scientific_name = 'Trifolium pratense'), 'chop-and-drop', 3, 'spring-summer', 90, 'Green manure and nitrogen release', 'chop-and-drop'),
((SELECT id FROM plants WHERE scientific_name = 'Trifolium repens'), 'mowing', 1, 'growing-season', 50, 'Living mulch maintenance', 'chop-and-drop'),
((SELECT id FROM plants WHERE scientific_name = 'Robinia pseudoacacia'), 'coppice', 36, 'winter', 100, 'Biomass production and nitrogen pulse', 'chop-and-drop'),
((SELECT id FROM plants WHERE scientific_name = 'Malus domestica'), 'structural-pruning', 12, 'winter', 20, 'Light penetration and air circulation', 'chop-and-drop'),
((SELECT id FROM plants WHERE scientific_name = 'Sambucus nigra'), 'chop-and-drop', 6, 'spring-fall', 50, 'Biomass and pest habitat', 'chop-and-drop');

-- Ecological interactions (syntropic relationships)
INSERT INTO ecological_interactions (plant_a_id, plant_b_id, interaction_type, strength, research_notes, syntropic_benefit) VALUES
-- Nitrogen sharing
((SELECT id FROM plants WHERE scientific_name = 'Trifolium repens'),
 (SELECT id FROM plants WHERE scientific_name = 'Malus domestica'),
 'nitrogen-sharing', 'strong', 'Clover fixes nitrogen that apple trees utilize', 'Ground cover provides continuous nitrogen input'),

((SELECT id FROM plants WHERE scientific_name = 'Robinia pseudoacacia'),
 (SELECT id FROM plants WHERE scientific_name = 'Prunus avium'),
 'nitrogen-sharing', 'moderate', 'Black locust enriches soil for cherry trees', 'Canopy layer nitrogen fixation'),

-- Pest deterrent
((SELECT id FROM plants WHERE scientific_name = 'Allium schoenoprasum'),
 (SELECT id FROM plants WHERE scientific_name = 'Malus domestica'),
 'pest-deterrent', 'strong', 'Chives repel aphids and Japanese beetles', 'Aromatic herbs protect fruit trees'),

-- Mycorrhizal network
((SELECT id FROM plants WHERE scientific_name = 'Malus domestica'),
 (SELECT id FROM plants WHERE scientific_name = 'Prunus avium'),
 'mycorrhizal-network', 'strong', 'Both form ectomycorrhizal associations and share nutrients', 'Underground nutrient sharing enhances both species'),

-- Deep nutrient mining
((SELECT id FROM plants WHERE scientific_name = 'Symphytum officinale'),
 (SELECT id FROM plants WHERE scientific_name = 'Vaccinium corymbosum'),
 'deep-nutrient-mining', 'strong', 'Comfrey mines deep nutrients for shallow-rooted blueberries', 'Comfrey prunings mulch blueberries'),

-- Nurse plant
((SELECT id FROM plants WHERE scientific_name = 'Robinia pseudoacacia'),
 (SELECT id FROM plants WHERE scientific_name = 'Quercus'),
 'nurse-plant', 'strong', 'Fast-growing locust provides shade and nitrogen for slow-growing oak', 'Pioneer accelerates succession'),

-- Humidity regulation
((SELECT id FROM plants WHERE scientific_name = 'Sambucus nigra'),
 (SELECT id FROM plants WHERE scientific_name = 'Rubus idaeus'),
 'humidity-regulation', 'moderate', 'Elderberry canopy creates humid microclimate for raspberries', 'Moisture retention in syntropic layers');

-- Create sample syntropic guild combining all these principles
INSERT INTO guilds (name, description, zone_min, zone_max, climate_type, primary_purpose, size_sqft, maintenance_level, expected_yield, public)
VALUES (
    'Temperate Food Forest (Syntropic)',
    'Complete syntropic guild with 4 succession stages: colonization (N-fixers), accumulation (dynamic accumulators), consolidation (fruit trees), abundance (mature forest). Implements chop-and-drop, companion planting, and mycorrhizal networks.',
    5, 8, 'temperate', 'food', 2000, 'medium',
    'Year 1-2: Biomass and nitrogen. Year 3-5: First fruit harvest. Year 5+: Abundant perennial food production with minimal inputs.',
    true
);

-- Add plants to the syntropic guild with succession timing
INSERT INTO guild_plants (guild_id, plant_id, quantity, planting_year, spacing_cm, notes)
SELECT
    (SELECT id FROM guilds WHERE name = 'Temperate Food Forest (Syntropic)'),
    id,
    CASE
        WHEN scientific_name = 'Trifolium repens' THEN 1000
        WHEN scientific_name = 'Trifolium pratense' THEN 50
        WHEN scientific_name = 'Symphytum officinale' THEN 20
        WHEN scientific_name = 'Malus domestica' THEN 3
        WHEN scientific_name = 'Prunus avium' THEN 2
        WHEN scientific_name = 'Vaccinium corymbosum' THEN 10
        WHEN scientific_name = 'Sambucus nigra' THEN 5
        WHEN scientific_name = 'Allium schoenoprasum' THEN 30
    END,
    CASE
        WHEN scientific_name IN ('Trifolium repens', 'Trifolium pratense') THEN 0
        WHEN scientific_name = 'Symphytum officinale' THEN 0
        WHEN scientific_name IN ('Sambucus nigra', 'Vaccinium corymbosum') THEN 1
        WHEN scientific_name IN ('Malus domestica', 'Prunus avium') THEN 2
        WHEN scientific_name = 'Allium schoenoprasum' THEN 1
    END,
    CASE
        WHEN scientific_name = 'Trifolium repens' THEN 30
        WHEN scientific_name = 'Trifolium pratense' THEN 50
        WHEN scientific_name = 'Symphytum officinale' THEN 90
        WHEN scientific_name = 'Malus domestica' THEN 600
        WHEN scientific_name = 'Prunus avium' THEN 700
        WHEN scientific_name = 'Vaccinium corymbosum' THEN 150
        WHEN scientific_name = 'Sambucus nigra' THEN 300
        WHEN scientific_name = 'Allium schoenoprasum' THEN 30
    END,
    CASE
        WHEN scientific_name = 'Trifolium repens' THEN 'Living mulch ground cover, continuous nitrogen fixation. Mow monthly and leave clippings.'
        WHEN scientific_name = 'Trifolium pratense' THEN 'Nitrogen-fixing pioneer. Chop-and-drop every 3 months for green manure.'
        WHEN scientific_name = 'Symphytum officinale' THEN 'Dynamic accumulator. Harvest leaves 4-6 times per year for mulch around fruit trees.'
        WHEN scientific_name = 'Malus domestica' THEN 'Canopy layer fruit production. Benefits from nitrogen fixers and comfrey mulch.'
        WHEN scientific_name = 'Prunus avium' THEN 'Sub-canopy fruit tree. Plant on north side of apples to avoid shading.'
        WHEN scientific_name = 'Vaccinium corymbosum' THEN 'Acid-loving shrub layer. Mulch with comfrey for nutrients.'
        WHEN scientific_name = 'Sambucus nigra' THEN 'Fast-growing shrub. Prune heavily for chop-and-drop biomass.'
        WHEN scientific_name = 'Allium schoenoprasum' THEN 'Pest-deterrent herb. Plant in rings around fruit trees.'
    END
FROM plants
WHERE scientific_name IN (
    'Trifolium repens', 'Trifolium pratense', 'Symphytum officinale',
    'Malus domestica', 'Prunus avium', 'Vaccinium corymbosum',
    'Sambucus nigra', 'Allium schoenoprasum'
);
