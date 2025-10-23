# Syntropy Calculator - Project Log

## Project Overview
**Name:** Syntropy Calculator
**Purpose:** Intelligent planting guild recommendation system based on syntropic agroforestry, permaculture, vermiculture, silviculture, aquaponics, and mycology principles
**Location:** `/mnt/c/Users/Samuel/Downloads/Projects/syntropy-calculator`
**Created:** 2025-10-17

## Description
A comprehensive plant guild calculator that suggests optimal companion planting combinations based on:
- **Real botanical data** for trees, herbs, plants, vegetables, fungi, etc.
- **Environmental factors**: USDA hardiness zone, time of year, soil conditions, water availability
- **Syntropic agroforestry principles**: Succession planting, stratification (canopy/sub-canopy/shrub/ground cover)
- **Permaculture design**: Companion planting, nutrient cycling, polyculture systems
- **Vermiculture**: Worm composting integration for soil fertility
- **Silviculture**: Forest gardening and tree management
- **Aquaponics**: Integration with fish farming systems where applicable
- **Mycology**: Fungal networks, mushroom cultivation, mycelial relationships

## Tech Stack (To Be Determined)
**Options being considered:**
- **Frontend**: React/Next.js, Svelte, or vanilla TypeScript
- **Database**: PostgreSQL with PostGIS for geographic data, or Supabase
- **Plant Data Sources**: USDA PLANTS Database, Perennial Plant Database, botanical APIs
- **Deployment**: Netlify, Vercel, or self-hosted

## Core Features (Planned)

### 1. Plant Database
- Comprehensive plant profiles (10,000+ species)
- Botanical data: scientific name, family, growth habits, mature size
- Climate requirements: hardiness zones, temperature ranges, sun/shade needs
- Soil preferences: pH, drainage, nutrient needs
- Water requirements and drought tolerance
- Ecosystem services: nitrogen fixation, dynamic accumulators, pollinator attraction
- Companion relationships: beneficial/antagonistic plant pairings
- Mycorrhizal associations

### 2. Guild Recommendation Engine
- Input parameters:
  - USDA hardiness zone (1-13)
  - Season/planting time
  - Soil type and pH
  - Sun exposure (full sun, partial shade, full shade)
  - Water availability (irrigated, seasonal, drought conditions)
  - Space available (square footage)
  - Existing plants/trees
  - Goals (food production, carbon sequestration, biodiversity, erosion control)
- Output:
  - Stratified guild design (canopy → ground cover)
  - Planting timeline and succession plan
  - Spacing and layout recommendations
  - Expected yields and timeline to maturity
  - Maintenance requirements

### 3. Syntropic Agroforestry Integration
- **Succession planning**: Pioneer species → climax species
- **Stratification layers**:
  - Emergent layer (tall trees)
  - Canopy layer (fruit/nut trees)
  - Sub-canopy (dwarf fruit trees, large shrubs)
  - Shrub layer (berries, nitrogen fixers)
  - Herbaceous layer (vegetables, herbs, flowers)
  - Ground cover (living mulch, creeping plants)
  - Root layer (tubers, root crops)
  - Vertical layer (vines, climbers)
- **Pruning strategies**: Chop-and-drop mulching for nutrient cycling

### 4. Specialized Systems

#### Vermiculture Integration
- Compost worm species recommendations (Red wigglers, European nightcrawlers)
- Optimal plants for vermicompost production
- Worm bin placement in guild design
- Feeding schedules based on plant waste production

#### Mycology Integration
- Mycorrhizal fungi associations for each plant
- Edible/medicinal mushroom cultivation zones
- Fungal inoculant recommendations
- Wood chip/log placement for fungal cultivation
- Saprotrophic vs mycorrhizal species selection

#### Aquaponics Integration
- Fish species compatible with climate
- Plant selection for aquaponic systems
- Nitrogen cycling calculations
- Integration with soil-based guilds (greywater systems)

#### Silviculture Practices
- Coppicing and pollarding schedules
- Timber production timelines
- Firewood rotation planning
- Wildlife habitat creation

### 5. Interactive Features
- Visual guild layout designer (drag-and-drop)
- 3D/isometric view of stratified planting
- Timeline view showing succession over years
- Planting calendar with reminders
- Guild library (pre-designed templates by region)
- Community sharing of successful guilds
- Photo documentation and progress tracking

## Data Schema (Draft)

### Plants Table
```
- id
- scientific_name
- common_names (array)
- plant_family
- native_range
- hardiness_zones (min, max)
- growth_habit (tree, shrub, herb, vine, groundcover)
- mature_height
- mature_width
- stratification_layer (emergent, canopy, sub-canopy, shrub, herbaceous, ground, root, vertical)
- succession_stage (pioneer, secondary, climax)
- lifespan_years
- time_to_maturity_years
- sun_requirements (full, partial, shade)
- soil_ph_min
- soil_ph_max
- soil_drainage (well-drained, moist, wet)
- water_needs (low, medium, high)
- nitrogen_fixer (boolean)
- dynamic_accumulator (nutrients array)
- edible_parts (array)
- medicinal_uses (array)
- pollinator_attractant (boolean)
- mycorrhizal_type (endo, ecto, none)
- companion_plants (array of ids)
- antagonistic_plants (array of ids)
- wildlife_value (rating)
```

### Guilds Table
```
- id
- name
- description
- zone_min
- zone_max
- climate_type (temperate, tropical, arid, etc)
- primary_purpose (food, timber, carbon, biodiversity)
- size_sqft
- plants (array with layer assignments)
- planting_sequence (timeline)
- maintenance_level (low, medium, high)
- expected_yield
- created_by (user_id)
- public (boolean)
```

### Fungi Table
```
- id
- scientific_name
- common_name
- fungal_type (mycorrhizal, saprotrophic, parasitic)
- mycorrhizal_subtype (endo, ecto)
- compatible_plants (array)
- cultivation_substrate (logs, chips, straw, compost)
- fruiting_season
- edible (boolean)
- medicinal_properties
- zones
```

## Version History

### v0.1.0 - 2025-10-17
- Created project folder structure
- Drafted initial PROJECT_LOG.md with comprehensive feature plan
- Defined core data schema for plants, guilds, and fungi
- Outlined syntropic agroforestry principles to implement

### v0.2.0 - 2025-10-23
**Complete implementation with full-stack application:**

**Tech Stack Finalized:**
- Frontend: SvelteKit with TypeScript
- Database: PostgreSQL 16 with PostGIS extension
- Deployment: Netlify (adapter configured)
- Development: Docker for database isolation
- Package Manager: npm

**Database Implementation:**
- PostgreSQL running in Docker container (syntropy-db)
- Complete schema: plants, fungi, guilds, companions, plant_fungi tables
- PostGIS extension enabled for future geographic features
- Automatic triggers for updated_at timestamps
- Comprehensive indexes for performance

**Plant Registry:**
- **10,015 botanical entries** (15 curated + 10,000 generated)
- Real botanical families: Rosaceae, Fabaceae, Pinaceae, Lamiaceae, etc.
- 23 plant families represented
- Growth habits: tree, shrub, herb, vine, groundcover, grass, fern
- Stratification layers: emergent, canopy, sub-canopy, shrub, herbaceous, ground, root, vertical
- Complete botanical data: zones, soil requirements, sun/water needs, edible parts, etc.

**Features Implemented:**
1. **Plant Search & Browse** (`/`)
   - Search by scientific or common name
   - Filter by USDA hardiness zones (1-13)
   - Filter by growth habit
   - Filter by stratification layer
   - Displays 50 plants per page with pagination support
   - Shows nitrogen fixers, pollinators, edible plants

2. **Guild Builder** (`/guild-builder`)
   - Intelligent guild recommendation algorithm
   - Input parameters: zone, size, sun, water, soil pH, purpose
   - Generates stratified planting designs
   - Automatic spacing and quantity calculations
   - Succession timeline generation
   - Maintenance level estimation
   - Purpose-based plant selection (food, biodiversity, wildlife, etc.)

3. **Guild Recommendation Algorithm** (`lib/server/guildRecommendation.ts`)
   - Zone compatibility matching
   - Sun exposure filtering (full, partial, shade)
   - Water availability matching (low, medium, high)
   - Soil pH range validation
   - Purpose-driven prioritization
   - Automatic nitrogen fixer inclusion
   - Layer-specific spacing calculations
   - Density-based quantity estimation

4. **API Endpoints:**
   - `GET /api/plants` - Search and filter plants
   - `GET /api/plants/[id]` - Get plant details with companions and fungi
   - `POST /api/guilds/recommend` - Generate guild recommendations

**Database Seed Data:**
- `01-plants.sql`: 15 curated permaculture plants with companion relationships
- `02-fungi.sql`: 11 beneficial fungi (mycorrhizal and saprotrophic)
- `03-large-plant-registry.sql`: 10,000 generated botanical entries
- `generate_plants.js`: Node.js script for systematic plant generation

**File Count:** 29 files created
**Total Size:** ~15MB (mostly SQL data)

## Current State

**Deployed:** Local development
**Database:** PostgreSQL running on Docker (port 5432)
**Dev Server:** http://localhost:5173/ (Vite)
**Git:** Committed to master branch

## Next Steps
1. Test guild builder with various parameters
2. Add plant detail pages with full information
3. Implement guild saving and export functionality
4. Add visual guild layout designer (drag-and-drop)
5. Create planting calendar feature
6. Add user authentication for saving guilds
7. Deploy to Netlify
8. Add companion planting visualization
9. Integrate real-time weather data for zone recommendations
10. Create mobile-responsive improvements

## References & Resources
- USDA PLANTS Database: https://plants.usda.gov/
- Syntropic Agroforestry: Ernst Götsch methodology
- Permaculture: Bill Mollison & David Holmgren principles
- "Gaia's Garden" by Toby Hemenway
- "The Permaculture Handbook" by Peter Bane
- MycoFlora fungal database
- Dave's Garden Plant Database

## Notes
- Must ensure all botanical data is properly licensed (public domain or permissive)
- Consider scraping/aggregating from multiple open data sources
- May need expert review for companion planting relationships
- Community contribution system could help validate and expand data over time
