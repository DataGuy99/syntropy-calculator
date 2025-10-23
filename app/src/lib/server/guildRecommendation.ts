import { sql } from './db';
import type { Plant } from './db';

export interface GuildParameters {
  zone: number;
  size_sqft: number;
  sun_exposure: 'full' | 'partial' | 'shade';
  water_availability: 'low' | 'medium' | 'high';
  soil_ph?: number;
  primary_purpose: 'food' | 'timber' | 'carbon' | 'biodiversity' | 'erosion-control' | 'wildlife';
  existing_plants?: number[];
}

export interface GuildRecommendation {
  layer: string;
  plants: Plant[];
  spacing_cm: number;
  quantity: number;
}

export interface GuildDesign {
  name: string;
  layers: GuildRecommendation[];
  total_plants: number;
  maintenance_level: 'low' | 'medium' | 'high';
  succession_timeline: string;
}

export async function generateGuildRecommendation(
  params: GuildParameters
): Promise<GuildDesign> {
  const { zone, size_sqft, sun_exposure, water_availability, soil_ph, primary_purpose } = params;

  // Convert sqft to square meters for easier spacing calculations
  const size_sqm = size_sqft * 0.092903;

  // Define layers to populate based on syntropic principles
  const layers = [
    'emergent',
    'canopy',
    'sub-canopy',
    'shrub',
    'herbaceous',
    'ground',
  ];

  const guildLayers: GuildRecommendation[] = [];

  for (const layer of layers) {
    const plants = await selectPlantsForLayer({
      layer,
      zone,
      sun_exposure,
      water_availability,
      soil_ph,
      primary_purpose,
    });

    if (plants.length > 0) {
      const spacing = getSpacingForLayer(layer);
      const quantity = calculateQuantity(size_sqm, spacing, layer);

      guildLayers.push({
        layer,
        plants: plants.slice(0, 5), // Top 5 recommendations per layer
        spacing_cm: spacing,
        quantity,
      });
    }
  }

  // Add nitrogen fixers if not already present
  const hasNitrogenFixers = guildLayers.some((layer) =>
    layer.plants.some((p) => p.nitrogen_fixer)
  );

  if (!hasNitrogenFixers) {
    const nitrogenFixers = await sql<Plant[]>`
      SELECT * FROM plants
      WHERE nitrogen_fixer = true
        AND hardiness_zone_min <= ${zone}
        AND hardiness_zone_max >= ${zone}
        AND water_needs = ${water_availability}
      ORDER BY RANDOM()
      LIMIT 3
    `;

    if (nitrogenFixers.length > 0) {
      guildLayers.push({
        layer: 'nitrogen-fixers',
        plants: nitrogenFixers,
        spacing_cm: 100,
        quantity: Math.ceil(size_sqm / 1),
      });
    }
  }

  const totalPlants = guildLayers.reduce((sum, layer) => sum + layer.quantity, 0);
  const maintenanceLevel = calculateMaintenanceLevel(guildLayers);
  const timeline = generateSuccessionTimeline(guildLayers);

  return {
    name: `${primary_purpose} Guild - Zone ${zone}`,
    layers: guildLayers,
    total_plants: totalPlants,
    maintenance_level: maintenanceLevel,
    succession_timeline: timeline,
  };
}

async function selectPlantsForLayer(criteria: {
  layer: string;
  zone: number;
  sun_exposure: string;
  water_availability: string;
  soil_ph?: number;
  primary_purpose: string;
}): Promise<Plant[]> {
  const { layer, zone, sun_exposure, water_availability, soil_ph, primary_purpose } = criteria;

  let query = sql<Plant[]>`
    SELECT * FROM plants
    WHERE stratification_layer = ${layer}
      AND hardiness_zone_min <= ${zone}
      AND hardiness_zone_max >= ${zone}
      AND (sun_requirements = ${sun_exposure} OR sun_requirements = 'any')
      AND water_needs = ${water_availability}
  `;

  if (soil_ph) {
    query = sql<Plant[]>`
      SELECT * FROM plants
      WHERE stratification_layer = ${layer}
        AND hardiness_zone_min <= ${zone}
        AND hardiness_zone_max >= ${zone}
        AND (sun_requirements = ${sun_exposure} OR sun_requirements = 'any')
        AND water_needs = ${water_availability}
        AND soil_ph_min <= ${soil_ph}
        AND soil_ph_max >= ${soil_ph}
    `;
  }

  // Prioritize based on purpose
  if (primary_purpose === 'food') {
    query = sql<Plant[]>`
      ${query}
      AND cardinality(edible_parts) > 0
      ORDER BY cardinality(edible_parts) DESC, wildlife_value DESC
      LIMIT 10
    `;
  } else if (primary_purpose === 'biodiversity' || primary_purpose === 'wildlife') {
    query = sql<Plant[]>`
      ${query}
      ORDER BY wildlife_value DESC, pollinator_attractant DESC
      LIMIT 10
    `;
  } else {
    query = sql<Plant[]>`
      ${query}
      ORDER BY RANDOM()
      LIMIT 10
    `;
  }

  return await query;
}

function getSpacingForLayer(layer: string): number {
  const spacings: Record<string, number> = {
    emergent: 800,
    canopy: 600,
    'sub-canopy': 400,
    shrub: 200,
    herbaceous: 50,
    ground: 30,
    'nitrogen-fixers': 100,
  };

  return spacings[layer] || 100;
}

function calculateQuantity(size_sqm: number, spacing_cm: number, layer: string): number {
  const spacing_m = spacing_cm / 100;
  const area_per_plant = spacing_m * spacing_m;

  // Different density rules per layer
  if (layer === 'emergent' || layer === 'canopy') {
    return Math.max(1, Math.floor(size_sqm / area_per_plant));
  } else if (layer === 'shrub' || layer === 'sub-canopy') {
    return Math.max(2, Math.floor((size_sqm / area_per_plant) * 0.8));
  } else {
    return Math.max(3, Math.floor((size_sqm / area_per_plant) * 0.6));
  }
}

function calculateMaintenanceLevel(
  layers: GuildRecommendation[]
): 'low' | 'medium' | 'high' {
  const herbaceousCount = layers.find((l) => l.layer === 'herbaceous')?.quantity || 0;
  const treeCount =
    (layers.find((l) => l.layer === 'emergent')?.quantity || 0) +
    (layers.find((l) => l.layer === 'canopy')?.quantity || 0);

  if (herbaceousCount > 20 || treeCount > 10) {
    return 'high';
  } else if (herbaceousCount > 10 || treeCount > 5) {
    return 'medium';
  }
  return 'low';
}

function generateSuccessionTimeline(layers: GuildRecommendation[]): string {
  const timelines = [];

  // Year 0-1: Ground covers and herbs
  if (layers.some((l) => l.layer === 'ground' || l.layer === 'herbaceous')) {
    timelines.push('Year 0-1: Establish ground covers and herbaceous layers');
  }

  // Year 1-3: Shrubs and nitrogen fixers
  if (layers.some((l) => l.layer === 'shrub' || l.layer === 'nitrogen-fixers')) {
    timelines.push('Year 1-3: Plant shrubs and nitrogen-fixing species');
  }

  // Year 2-5: Sub-canopy and canopy
  if (layers.some((l) => l.layer === 'sub-canopy' || l.layer === 'canopy')) {
    timelines.push('Year 2-5: Introduce fruit trees and sub-canopy species');
  }

  // Year 5+: Emergent layer
  if (layers.some((l) => l.layer === 'emergent')) {
    timelines.push('Year 5+: Plant emergent layer trees for long-term structure');
  }

  return timelines.join(' → ');
}
