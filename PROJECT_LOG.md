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

## Next Steps
1. Choose tech stack (evaluate React vs Svelte vs Next.js)
2. Set up git repository
3. Research botanical data APIs and licensing
4. Design database schema in detail
5. Create initial UI mockups
6. Begin plant database population (start with 100 common permaculture species)

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
