-- Syntropic Agroforestry Enhancements
-- Based on Ernst Götsch methodology

-- Add syntropic-specific columns to plants table
ALTER TABLE plants ADD COLUMN IF NOT EXISTS pruning_strategy TEXT CHECK (pruning_strategy IN ('coppice', 'pollard', 'chop-and-drop', 'minimal', 'none'));
ALTER TABLE plants ADD COLUMN IF NOT EXISTS pruning_frequency_months INTEGER;
ALTER TABLE plants ADD COLUMN IF NOT EXISTS biomass_production TEXT CHECK (biomass_production IN ('very-high', 'high', 'medium', 'low'));
ALTER TABLE plants ADD COLUMN IF NOT EXISTS shade_tolerance TEXT CHECK (shade_tolerance IN ('full-shade', 'partial-shade', 'shade-intolerant'));
ALTER TABLE plants ADD COLUMN IF NOT EXISTS root_depth TEXT CHECK (root_depth IN ('shallow', 'medium', 'deep', 'very-deep'));
ALTER TABLE plants ADD COLUMN IF NOT EXISTS root_type TEXT CHECK (root_type IN ('fibrous', 'taproot', 'tuberous', 'rhizomatous'));
ALTER TABLE plants ADD COLUMN IF NOT EXISTS allelopathic BOOLEAN DEFAULT false;
ALTER TABLE plants ADD COLUMN IF NOT EXISTS allelopathic_effect TEXT;
ALTER TABLE plants ADD COLUMN IF NOT EXISTS pioneer_characteristics TEXT[];
ALTER TABLE plants ADD COLUMN IF NOT EXISTS canopy_density TEXT CHECK (canopy_density IN ('very-dense', 'dense', 'medium', 'open', 'very-open'));
ALTER TABLE plants ADD COLUMN IF NOT EXISTS leaf_litter_quality TEXT CHECK (leaf_litter_quality IN ('excellent', 'good', 'fair', 'poor'));
ALTER TABLE plants ADD COLUMN IF NOT EXISTS co2_sequestration_kg_per_year NUMERIC;
ALTER TABLE plants ADD COLUMN IF NOT EXISTS drought_deciduous BOOLEAN DEFAULT false;
ALTER TABLE plants ADD COLUMN IF NOT EXISTS frost_tolerance_celsius INTEGER;
ALTER TABLE plants ADD COLUMN IF NOT EXISTS wind_tolerance TEXT CHECK (wind_tolerance IN ('excellent', 'good', 'fair', 'poor'));
ALTER TABLE plants ADD COLUMN IF NOT EXISTS salt_tolerance BOOLEAN DEFAULT false;
ALTER TABLE plants ADD COLUMN IF NOT EXISTS flood_tolerance BOOLEAN DEFAULT false;
ALTER TABLE plants ADD COLUMN IF NOT EXISTS fire_resistant BOOLEAN DEFAULT false;
ALTER TABLE plants ADD COLUMN IF NOT EXISTS regenerates_from_cutting BOOLEAN DEFAULT false;
ALTER TABLE plants ADD COLUMN IF NOT EXISTS seed_viability_years INTEGER;
ALTER TABLE plants ADD COLUMN IF NOT EXISTS native_regions TEXT[];
ALTER TABLE plants ADD COLUMN IF NOT EXISTS invasive_regions TEXT[];

-- Syntropic succession stages (more detailed than basic succession_stage)
CREATE TABLE IF NOT EXISTS syntropic_succession_stages (
    id SERIAL PRIMARY KEY,
    plant_id INTEGER REFERENCES plants(id) ON DELETE CASCADE,
    stage_name TEXT NOT NULL CHECK (stage_name IN ('colonization', 'accumulation', 'consolidation', 'abundance')),
    stage_order INTEGER NOT NULL,
    years_active_min INTEGER,
    years_active_max INTEGER,
    role TEXT NOT NULL,
    management_notes TEXT,
    UNIQUE(plant_id, stage_name)
);

-- Nutrient cycling and dynamic accumulators (enhanced)
CREATE TABLE IF NOT EXISTS nutrient_accumulation (
    id SERIAL PRIMARY KEY,
    plant_id INTEGER REFERENCES plants(id) ON DELETE CASCADE,
    nutrient TEXT NOT NULL,
    concentration_level TEXT CHECK (concentration_level IN ('very-high', 'high', 'medium', 'low')),
    accumulation_location TEXT CHECK (accumulation_location IN ('leaves', 'stems', 'roots', 'whole-plant')),
    release_rate TEXT CHECK (release_rate IN ('fast', 'medium', 'slow')),
    cycling_notes TEXT
);

-- Guild templates based on syntropic principles
CREATE TABLE IF NOT EXISTS syntropic_guild_templates (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    description TEXT,
    climate_type TEXT,
    size_sqm_min INTEGER,
    size_sqm_max INTEGER,
    primary_function TEXT,
    succession_strategy TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Guild template plants (pre-designed combinations)
CREATE TABLE IF NOT EXISTS guild_template_plants (
    id SERIAL PRIMARY KEY,
    template_id UUID REFERENCES syntropic_guild_templates(id) ON DELETE CASCADE,
    plant_id INTEGER REFERENCES plants(id) ON DELETE CASCADE,
    role TEXT NOT NULL,
    planting_year INTEGER NOT NULL,
    quantity_per_100sqm INTEGER,
    spacing_cm INTEGER,
    succession_notes TEXT,
    pruning_schedule TEXT
);

-- Planting patterns and spacing strategies
CREATE TABLE IF NOT EXISTS planting_patterns (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT,
    pattern_type TEXT CHECK (pattern_type IN ('row', 'cluster', 'random', 'keyhole', 'mandala', 'food-forest-strip')),
    spacing_formula TEXT,
    density_plants_per_sqm NUMERIC,
    syntropic_phase TEXT,
    diagram_url TEXT
);

-- Pruning schedules and chop-and-drop strategies
CREATE TABLE IF NOT EXISTS pruning_schedules (
    id SERIAL PRIMARY KEY,
    plant_id INTEGER REFERENCES plants(id) ON DELETE CASCADE,
    pruning_type TEXT NOT NULL,
    frequency_months INTEGER,
    season TEXT,
    percentage_to_prune INTEGER,
    purpose TEXT,
    biomass_disposal TEXT CHECK (biomass_disposal IN ('chop-and-drop', 'compost', 'mulch', 'animal-fodder', 'biochar'))
);

-- Ecological relationships beyond simple companions
CREATE TABLE IF NOT EXISTS ecological_interactions (
    id SERIAL PRIMARY KEY,
    plant_a_id INTEGER REFERENCES plants(id) ON DELETE CASCADE,
    plant_b_id INTEGER REFERENCES plants(id) ON DELETE CASCADE,
    interaction_type TEXT CHECK (interaction_type IN (
        'nitrogen-sharing', 'pest-deterrent', 'pollinator-attraction',
        'mycorrhizal-network', 'allelopathic-suppression', 'windbreak',
        'nurse-plant', 'trap-crop', 'sacrificial-crop', 'habitat-provision',
        'humidity-regulation', 'soil-structure', 'deep-nutrient-mining'
    )),
    strength TEXT CHECK (strength IN ('strong', 'moderate', 'weak')),
    research_notes TEXT,
    syntropic_benefit TEXT
);

-- Indexes for performance
CREATE INDEX IF NOT EXISTS idx_succession_stages_plant ON syntropic_succession_stages(plant_id);
CREATE INDEX IF NOT EXISTS idx_nutrient_accumulation_plant ON nutrient_accumulation(plant_id);
CREATE INDEX IF NOT EXISTS idx_nutrient_accumulation_nutrient ON nutrient_accumulation(nutrient);
CREATE INDEX IF NOT EXISTS idx_guild_template_plants_template ON guild_template_plants(template_id);
CREATE INDEX IF NOT EXISTS idx_pruning_schedules_plant ON pruning_schedules(plant_id);
CREATE INDEX IF NOT EXISTS idx_ecological_interactions_plants ON ecological_interactions(plant_a_id, plant_b_id);

-- Insert syntropic succession data for existing plants
INSERT INTO syntropic_succession_stages (plant_id, stage_name, stage_order, years_active_min, years_active_max, role, management_notes)
SELECT id, 'colonization', 1, 0, 2, 'Pioneer species for rapid biomass', 'Prune heavily in year 2'
FROM plants WHERE succession_stage = 'pioneer' AND nitrogen_fixer = true;

INSERT INTO syntropic_succession_stages (plant_id, stage_name, stage_order, years_active_min, years_active_max, role, management_notes)
SELECT id, 'accumulation', 2, 2, 5, 'Build soil organic matter', 'Chop-and-drop pruning every 6 months'
FROM plants WHERE succession_stage = 'secondary' AND growth_habit IN ('shrub', 'herb');

INSERT INTO syntropic_succession_stages (plant_id, stage_name, stage_order, years_active_min, years_active_max, role, management_notes)
SELECT id, 'consolidation', 3, 5, 15, 'Establish productive canopy', 'Strategic pruning to optimize light'
FROM plants WHERE succession_stage = 'secondary' AND growth_habit = 'tree';

INSERT INTO syntropic_succession_stages (plant_id, stage_name, stage_order, years_active_min, years_active_max, role, management_notes)
SELECT id, 'abundance', 4, 15, 100, 'Mature food production and ecosystem services', 'Minimal intervention, observe and guide'
FROM plants WHERE succession_stage = 'climax';

-- Sample guild templates
INSERT INTO syntropic_guild_templates (name, description, climate_type, size_sqm_min, size_sqm_max, primary_function, succession_strategy)
VALUES
('Tropical Food Forest Starter', 'Fast-growing tropical guild with banana, papaya, pigeon pea', 'tropical', 50, 200, 'food', 'Rapid colonization with nitrogen fixers'),
('Temperate Fruit Guild', 'Apple/pear guild with nitrogen-fixing shrubs and herbs', 'temperate', 100, 500, 'food', 'Long-term orchard with understory'),
('Restoration Guild', 'Degraded soil restoration with pioneers and deep-rooted species', 'any', 200, 2000, 'carbon', 'Heavy biomass production and soil building'),
('Drought-Tolerant Guild', 'Mediterranean climate with olives, figs, and drought-adapted species', 'arid', 100, 1000, 'food', 'Water-conserving with deep mulch');
