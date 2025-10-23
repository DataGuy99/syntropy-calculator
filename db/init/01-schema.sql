-- Enable PostGIS extension for geographic data
CREATE EXTENSION IF NOT EXISTS postgis;

-- Plants table
CREATE TABLE plants (
    id SERIAL PRIMARY KEY,
    scientific_name VARCHAR(255) NOT NULL UNIQUE,
    common_names TEXT[] DEFAULT '{}',
    plant_family VARCHAR(255),
    native_range TEXT,
    hardiness_zone_min INTEGER,
    hardiness_zone_max INTEGER,
    growth_habit VARCHAR(50) CHECK (growth_habit IN ('tree', 'shrub', 'herb', 'vine', 'groundcover', 'grass', 'fern')),
    mature_height_cm INTEGER,
    mature_width_cm INTEGER,
    stratification_layer VARCHAR(50) CHECK (stratification_layer IN ('emergent', 'canopy', 'sub-canopy', 'shrub', 'herbaceous', 'ground', 'root', 'vertical')),
    succession_stage VARCHAR(50) CHECK (succession_stage IN ('pioneer', 'secondary', 'climax')),
    lifespan_years INTEGER,
    time_to_maturity_years INTEGER,
    sun_requirements VARCHAR(20) CHECK (sun_requirements IN ('full', 'partial', 'shade', 'any')),
    soil_ph_min DECIMAL(3,1),
    soil_ph_max DECIMAL(3,1),
    soil_drainage VARCHAR(50) CHECK (soil_drainage IN ('well-drained', 'moist', 'wet', 'any')),
    water_needs VARCHAR(20) CHECK (water_needs IN ('low', 'medium', 'high')),
    nitrogen_fixer BOOLEAN DEFAULT FALSE,
    dynamic_accumulator TEXT[] DEFAULT '{}',
    edible_parts TEXT[] DEFAULT '{}',
    medicinal_uses TEXT[] DEFAULT '{}',
    pollinator_attractant BOOLEAN DEFAULT FALSE,
    mycorrhizal_type VARCHAR(20) CHECK (mycorrhizal_type IN ('endo', 'ecto', 'both', 'none')),
    wildlife_value INTEGER CHECK (wildlife_value >= 0 AND wildlife_value <= 10),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Companion relationships table (many-to-many)
CREATE TABLE plant_companions (
    id SERIAL PRIMARY KEY,
    plant_id INTEGER REFERENCES plants(id) ON DELETE CASCADE,
    companion_id INTEGER REFERENCES plants(id) ON DELETE CASCADE,
    relationship_type VARCHAR(20) CHECK (relationship_type IN ('beneficial', 'antagonistic', 'neutral')),
    notes TEXT,
    UNIQUE(plant_id, companion_id)
);

-- Fungi table
CREATE TABLE fungi (
    id SERIAL PRIMARY KEY,
    scientific_name VARCHAR(255) NOT NULL UNIQUE,
    common_name VARCHAR(255),
    fungal_type VARCHAR(50) CHECK (fungal_type IN ('mycorrhizal', 'saprotrophic', 'parasitic')),
    mycorrhizal_subtype VARCHAR(20) CHECK (mycorrhizal_subtype IN ('endo', 'ecto', 'both', NULL)),
    cultivation_substrate TEXT[] DEFAULT '{}',
    fruiting_season VARCHAR(50),
    edible BOOLEAN DEFAULT FALSE,
    medicinal_properties TEXT[] DEFAULT '{}',
    hardiness_zone_min INTEGER,
    hardiness_zone_max INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Plant-Fungi associations
CREATE TABLE plant_fungi (
    id SERIAL PRIMARY KEY,
    plant_id INTEGER REFERENCES plants(id) ON DELETE CASCADE,
    fungi_id INTEGER REFERENCES fungi(id) ON DELETE CASCADE,
    association_strength VARCHAR(20) CHECK (association_strength IN ('obligate', 'facultative', 'beneficial')),
    UNIQUE(plant_id, fungi_id)
);

-- Guilds table
CREATE TABLE guilds (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    zone_min INTEGER,
    zone_max INTEGER,
    climate_type VARCHAR(50) CHECK (climate_type IN ('temperate', 'tropical', 'subtropical', 'arid', 'mediterranean', 'continental')),
    primary_purpose VARCHAR(50) CHECK (primary_purpose IN ('food', 'timber', 'carbon', 'biodiversity', 'erosion-control', 'wildlife')),
    size_sqft INTEGER,
    maintenance_level VARCHAR(20) CHECK (maintenance_level IN ('low', 'medium', 'high')),
    expected_yield TEXT,
    public BOOLEAN DEFAULT FALSE,
    created_by VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Guild plants (plants assigned to guilds with layer information)
CREATE TABLE guild_plants (
    id SERIAL PRIMARY KEY,
    guild_id INTEGER REFERENCES guilds(id) ON DELETE CASCADE,
    plant_id INTEGER REFERENCES plants(id) ON DELETE CASCADE,
    quantity INTEGER DEFAULT 1,
    planting_year INTEGER DEFAULT 0,
    spacing_cm INTEGER,
    notes TEXT,
    UNIQUE(guild_id, plant_id)
);

-- Indexes for performance
CREATE INDEX idx_plants_zone ON plants(hardiness_zone_min, hardiness_zone_max);
CREATE INDEX idx_plants_growth_habit ON plants(growth_habit);
CREATE INDEX idx_plants_layer ON plants(stratification_layer);
CREATE INDEX idx_guilds_zone ON guilds(zone_min, zone_max);
CREATE INDEX idx_guild_plants_guild ON guild_plants(guild_id);

-- Updated_at trigger function
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Apply triggers
CREATE TRIGGER update_plants_updated_at BEFORE UPDATE ON plants
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_fungi_updated_at BEFORE UPDATE ON fungi
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_guilds_updated_at BEFORE UPDATE ON guilds
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
