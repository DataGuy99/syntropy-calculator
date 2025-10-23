import postgres from 'postgres';
import { env } from '$env/dynamic/private';

const DATABASE_URL = env.DATABASE_URL || 'postgresql://syntropy:syntropy_dev_password@localhost:5432/syntropy_calculator';

export const sql = postgres(DATABASE_URL, {
  max: 10,
  idle_timeout: 20,
  connect_timeout: 10,
});

export interface Plant {
  id: number;
  scientific_name: string;
  common_names: string[];
  plant_family: string | null;
  native_range: string | null;
  hardiness_zone_min: number | null;
  hardiness_zone_max: number | null;
  growth_habit: 'tree' | 'shrub' | 'herb' | 'vine' | 'groundcover' | 'grass' | 'fern' | null;
  mature_height_cm: number | null;
  mature_width_cm: number | null;
  stratification_layer: 'emergent' | 'canopy' | 'sub-canopy' | 'shrub' | 'herbaceous' | 'ground' | 'root' | 'vertical' | null;
  succession_stage: 'pioneer' | 'secondary' | 'climax' | null;
  lifespan_years: number | null;
  time_to_maturity_years: number | null;
  sun_requirements: 'full' | 'partial' | 'shade' | 'any' | null;
  soil_ph_min: number | null;
  soil_ph_max: number | null;
  soil_drainage: 'well-drained' | 'moist' | 'wet' | 'any' | null;
  water_needs: 'low' | 'medium' | 'high' | null;
  nitrogen_fixer: boolean;
  dynamic_accumulator: string[];
  edible_parts: string[];
  medicinal_uses: string[];
  pollinator_attractant: boolean;
  mycorrhizal_type: 'endo' | 'ecto' | 'both' | 'none' | null;
  wildlife_value: number | null;
  created_at: Date;
  updated_at: Date;
}

export interface Guild {
  id: number;
  name: string;
  description: string | null;
  zone_min: number | null;
  zone_max: number | null;
  climate_type: 'temperate' | 'tropical' | 'subtropical' | 'arid' | 'mediterranean' | 'continental' | null;
  primary_purpose: 'food' | 'timber' | 'carbon' | 'biodiversity' | 'erosion-control' | 'wildlife' | null;
  size_sqft: number | null;
  maintenance_level: 'low' | 'medium' | 'high' | null;
  expected_yield: string | null;
  public: boolean;
  created_by: string | null;
  created_at: Date;
  updated_at: Date;
}

export interface Fungi {
  id: number;
  scientific_name: string;
  common_name: string | null;
  fungal_type: 'mycorrhizal' | 'saprotrophic' | 'parasitic' | null;
  mycorrhizal_subtype: 'endo' | 'ecto' | 'both' | null;
  cultivation_substrate: string[];
  fruiting_season: string | null;
  edible: boolean;
  medicinal_properties: string[];
  hardiness_zone_min: number | null;
  hardiness_zone_max: number | null;
  created_at: Date;
  updated_at: Date;
}
