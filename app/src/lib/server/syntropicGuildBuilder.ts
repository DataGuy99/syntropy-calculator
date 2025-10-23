import { sql } from './db';

export interface SyntropicGuildParameters {
  zone: number;
  size_sqft: number;
  sun_exposure: 'full' | 'partial' | 'shade';
  water_availability: 'low' | 'medium' | 'high';
  soil_ph?: number;
  primary_purpose: 'food' | 'timber' | 'carbon' | 'biodiversity' | 'erosion-control' | 'wildlife' | 'restoration';
  years_to_plan: number;
  existing_plants?: number[];
}

export interface SyntropicPlantRecommendation {
  plant: any;
  succession_stage: string;
  planting_year: number;
  quantity: number;
  spacing_cm: number;
  role: string;
  pruning_schedule?: string;
  nutrient_accumulation?: any[];
  management_notes: string;
}

export interface SyntropicGuild {
  name: string;
  description: string;
  succession_phases: {
    phase: string;
    years: string;
    plants: SyntropicPlantRecommendation[];
    goals: string;
    management: string;
  }[];
  total_plants: number;
  biomass_production_strategy: string;
  nutrient_cycling_plan: string;
  succession_timeline: string;
  maintenance_calendar: {
    month: string;
    tasks: string[];
  }[];
}

export async function generateSyntropicGuild(
  params: SyntropicGuildParameters
): Promise<SyntropicGuild> {
  const size_sqm = params.size_sqft * 0.092903;

  // Phase 1: COLONIZATION (Year 0-2)
  // Fast-growing nitrogen fixers and pioneers
  const colonizationPlants = await sql`
    SELECT p.*, ss.role, ss.management_notes, ss.years_active_min, ss.years_active_max
    FROM plants p
    LEFT JOIN syntropic_succession_stages ss ON p.id = ss.plant_id AND ss.stage_name = 'colonization'
    WHERE p.hardiness_zone_min <= ${params.zone}
      AND p.hardiness_zone_max >= ${params.zone}
      AND p.water_needs = ${params.water_availability}
      AND (p.nitrogen_fixer = true OR p.succession_stage = 'pioneer')
      AND p.biomass_production IN ('very-high', 'high')
    ORDER BY p.nitrogen_fixer DESC, p.biomass_production DESC
    LIMIT 5
  `;

  // Phase 2: ACCUMULATION (Year 1-5)
  // Dynamic accumulators and fast-growing shrubs
  const accumulationPlants = await sql`
    SELECT DISTINCT p.*, ss.role, ss.management_notes,
      array_agg(DISTINCT na.nutrient) FILTER (WHERE na.nutrient IS NOT NULL) as nutrients_accumulated
    FROM plants p
    LEFT JOIN syntropic_succession_stages ss ON p.id = ss.plant_id AND ss.stage_name = 'accumulation'
    LEFT JOIN nutrient_accumulation na ON p.id = na.plant_id
    WHERE p.hardiness_zone_min <= ${params.zone}
      AND p.hardiness_zone_max >= ${params.zone}
      AND p.water_needs = ${params.water_availability}
      AND (cardinality(p.dynamic_accumulator) > 0 OR p.growth_habit IN ('shrub', 'herb'))
      AND p.pruning_strategy IN ('chop-and-drop', 'coppice')
    GROUP BY p.id, ss.role, ss.management_notes
    ORDER BY cardinality(p.dynamic_accumulator) DESC
    LIMIT 5
  `;

  // Phase 3: CONSOLIDATION (Year 2-15)
  // Productive fruit/nut trees and perennials
  const consolidationPlants = await sql`
    SELECT p.*, ss.role, ss.management_notes
    FROM plants p
    LEFT JOIN syntropic_succession_stages ss ON p.id = ss.plant_id AND ss.stage_name = 'consolidation'
    WHERE p.hardiness_zone_min <= ${params.zone}
      AND p.hardiness_zone_max >= ${params.zone}
      AND p.water_needs = ${params.water_availability}
      AND p.growth_habit IN ('tree', 'shrub')
      AND p.stratification_layer IN ('canopy', 'sub-canopy', 'shrub')
      AND (
        (${params.primary_purpose} = 'food' AND cardinality(p.edible_parts) > 0)
        OR (${params.primary_purpose} = 'carbon' AND p.co2_sequestration_kg_per_year > 100)
        OR (${params.primary_purpose} IN ('biodiversity', 'wildlife') AND p.wildlife_value > 6)
        OR ${params.primary_purpose} = 'restoration'
      )
    ORDER BY
      CASE WHEN ${params.primary_purpose} = 'food' THEN cardinality(p.edible_parts) ELSE 0 END DESC,
      p.wildlife_value DESC
    LIMIT 6
  `;

  // Phase 4: ABUNDANCE (Year 5+)
  // Climax species and long-term producers
  const abundancePlants = await sql`
    SELECT p.*, ss.role, ss.management_notes
    FROM plants p
    LEFT JOIN syntropic_succession_stages ss ON p.id = ss.plant_id AND ss.stage_name = 'abundance'
    WHERE p.hardiness_zone_min <= ${params.zone}
      AND p.hardiness_zone_max >= ${params.zone}
      AND p.succession_stage = 'climax'
      AND p.lifespan_years > 30
    ORDER BY p.co2_sequestration_kg_per_year DESC NULLS LAST
    LIMIT 3
  `;

  // Get companion planting and ecological interactions
  const interactions = await sql`
    SELECT
      ei.plant_a_id,
      ei.plant_b_id,
      ei.interaction_type,
      ei.syntropic_benefit,
      p1.scientific_name as plant_a_name,
      p2.scientific_name as plant_b_name
    FROM ecological_interactions ei
    JOIN plants p1 ON ei.plant_a_id = p1.id
    JOIN plants p2 ON ei.plant_b_id = p2.id
    WHERE ei.strength IN ('strong', 'moderate')
  `;

  // Build succession phases
  const phases = [
    {
      phase: 'Colonization',
      years: 'Year 0-2',
      plants: colonizationPlants.map((p: any) => ({
        plant: p,
        succession_stage: 'colonization',
        planting_year: 0,
        quantity: calculateQuantity(size_sqm, 100, 'pioneer'),
        spacing_cm: 100,
        role: p.role || 'Rapid biomass production and nitrogen fixation',
        pruning_schedule: 'Heavy chop-and-drop every 2-3 months',
        management_notes: p.management_notes || 'Prune aggressively to build soil organic matter. Leave all biomass on-site.',
      })),
      goals: 'Rapid soil coverage, nitrogen fixation, biomass production, weed suppression',
      management: 'Intensive chop-and-drop pruning. All biomass stays on site. Water during establishment only.',
    },
    {
      phase: 'Accumulation',
      years: 'Year 1-5',
      plants: accumulationPlants.map((p: any) => ({
        plant: p,
        succession_stage: 'accumulation',
        planting_year: 1,
        quantity: calculateQuantity(size_sqm, 150, 'accumulator'),
        spacing_cm: 150,
        role: p.role || 'Nutrient cycling and soil building',
        pruning_schedule: 'Chop-and-drop 3-4 times per year',
        nutrient_accumulation: p.nutrients_accumulated,
        management_notes: p.management_notes || 'Mine deep nutrients and create rich mulch. Focus prunings around fruit trees.',
      })),
      goals: 'Build soil fertility, establish nutrient cycling, create microclimates',
      management: 'Regular pruning for mulch. Begin establishing mycorrhizal networks. Minimal external inputs.',
    },
    {
      phase: 'Consolidation',
      years: 'Year 2-15',
      plants: consolidationPlants.map((p: any) => ({
        plant: p,
        succession_stage: 'consolidation',
        planting_year: 2,
        quantity: calculateQuantity(size_sqm, p.mature_width_cm || 400, 'tree'),
        spacing_cm: p.mature_width_cm || 400,
        role: p.role || 'Food production and canopy establishment',
        pruning_schedule: p.pruning_strategy === 'minimal' ? 'Annual structural pruning' : 'Strategic pruning for light penetration',
        management_notes: p.management_notes || 'Allow trees to establish. Prune strategically to optimize light for understory.',
      })),
      goals: 'Establish productive canopy, optimize light distribution, maximize yields',
      management: 'Transition to low-intervention. Observe and guide succession. Harvest abundance.',
    },
    {
      phase: 'Abundance',
      years: 'Year 5-50+',
      plants: abundancePlants.map((p: any) => ({
        plant: p,
        succession_stage: 'abundance',
        planting_year: 3,
        quantity: calculateQuantity(size_sqm, p.mature_width_cm || 800, 'climax'),
        spacing_cm: p.mature_width_cm || 800,
        role: p.role || 'Long-term ecosystem services and production',
        pruning_schedule: 'Minimal intervention',
        management_notes: p.management_notes || 'Mature forest garden. Harvest, observe, and enjoy.',
      })),
      goals: 'Self-sustaining food forest, maximum biodiversity, carbon storage',
      management: 'Minimal maintenance. System self-regulates through succession dynamics.',
    },
  ];

  const totalPlants = phases.reduce(
    (sum, phase) => sum + phase.plants.reduce((s, p) => s + p.quantity, 0),
    0
  );

  return {
    name: `Syntropic ${capitalizeFirst(params.primary_purpose)} Guild - Zone ${params.zone}`,
    description: `Multi-phase syntropic agroforestry system designed for ${params.primary_purpose}. Follows Ernst Götsch succession principles with colonization, accumulation, consolidation, and abundance phases.`,
    succession_phases: phases,
    total_plants: totalPlants,
    biomass_production_strategy: 'Continuous chop-and-drop from fast-growing pioneers feeds slower-growing productive species. All biomass remains on-site for nutrient cycling.',
    nutrient_cycling_plan: 'Nitrogen fixers + dynamic accumulators + deep-rooted miners create complete nutrient cycle. Mycorrhizal networks share resources between plants.',
    succession_timeline: `${params.years_to_plan} year plan: Start with pioneers (Year 0), add accumulators (Year 1), establish productive species (Year 2), introduce climax species (Year 3+). System reaches maturity around Year 10-15.`,
    maintenance_calendar: generateMaintenanceCalendar(),
  };
}

function calculateQuantity(size_sqm: number, spacing_cm: number, type: string): number {
  const spacing_m = spacing_cm / 100;
  const area_per_plant = spacing_m * spacing_m;

  switch (type) {
    case 'pioneer':
      return Math.max(10, Math.floor((size_sqm / area_per_plant) * 1.5));
    case 'accumulator':
      return Math.max(5, Math.floor(size_sqm / area_per_plant));
    case 'tree':
      return Math.max(2, Math.floor((size_sqm / area_per_plant) * 0.7));
    case 'climax':
      return Math.max(1, Math.floor((size_sqm / area_per_plant) * 0.5));
    default:
      return Math.floor(size_sqm / area_per_plant);
  }
}

function capitalizeFirst(str: string): string {
  return str.charAt(0).toUpperCase() + str.slice(1);
}

function generateMaintenanceCalendar() {
  return [
    {
      month: 'January-February',
      tasks: [
        'Structural pruning of deciduous trees (dormant season)',
        'Plan spring planting strategy',
        'Assess winter damage and make replacements',
      ],
    },
    {
      month: 'March-April',
      tasks: [
        'Plant new trees and shrubs',
        'Heavy chop-and-drop of nitrogen fixers',
        'Mulch fruit trees with comfrey',
        'Observe spring succession patterns',
      ],
    },
    {
      month: 'May-June',
      tasks: [
        'First comfrey harvest for mulch',
        'Chop-and-drop clover and pioneers',
        'Thin excessive growth for light penetration',
        'Monitor pest-beneficial relationships',
      ],
    },
    {
      month: 'July-August',
      tasks: [
        'Second comfrey harvest',
        'Continue chop-and-drop of fast growers',
        'Harvest early fruits',
        'Ensure adequate water during establishment',
      ],
    },
    {
      month: 'September-October',
      tasks: [
        'Final comfrey harvest before frost',
        'Main fruit/nut harvest',
        'Collect seeds from successful plants',
        'Plant garlic and overwintering crops',
      ],
    },
    {
      month: 'November-December',
      tasks: [
        'Final chop-and-drop before winter',
        'Assess year success and plan improvements',
        'Protect tender plants if needed',
        'Rest and observe',
      ],
    },
  ];
}
