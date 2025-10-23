import { json } from '@sveltejs/kit';
import { sql } from '$lib/server/db';
import type { RequestHandler } from './$types';

export const GET: RequestHandler = async ({ url }) => {
  const search = url.searchParams.get('search') || '';
  const zone = url.searchParams.get('zone');
  const habit = url.searchParams.get('habit');
  const layer = url.searchParams.get('layer');
  const limit = parseInt(url.searchParams.get('limit') || '50');
  const offset = parseInt(url.searchParams.get('offset') || '0');

  let query = sql`
    SELECT
      id, scientific_name, common_names, plant_family,
      hardiness_zone_min, hardiness_zone_max,
      growth_habit, stratification_layer, mature_height_cm,
      sun_requirements, water_needs, nitrogen_fixer,
      edible_parts, pollinator_attractant, wildlife_value
    FROM plants
    WHERE 1=1
  `;

  const conditions = [];

  if (search) {
    conditions.push(sql`(
      scientific_name ILIKE ${'%' + search + '%'} OR
      EXISTS (
        SELECT 1 FROM unnest(common_names) AS common_name
        WHERE common_name ILIKE ${'%' + search + '%'}
      )
    )`);
  }

  if (zone) {
    const zoneNum = parseInt(zone);
    conditions.push(sql`(
      hardiness_zone_min <= ${zoneNum} AND
      hardiness_zone_max >= ${zoneNum}
    )`);
  }

  if (habit) {
    conditions.push(sql`growth_habit = ${habit}`);
  }

  if (layer) {
    conditions.push(sql`stratification_layer = ${layer}`);
  }

  if (conditions.length > 0) {
    query = sql`
      SELECT
        id, scientific_name, common_names, plant_family,
        hardiness_zone_min, hardiness_zone_max,
        growth_habit, stratification_layer, mature_height_cm,
        sun_requirements, water_needs, nitrogen_fixer,
        edible_parts, pollinator_attractant, wildlife_value
      FROM plants
      WHERE ${sql(conditions, ' AND ')}
      ORDER BY scientific_name
      LIMIT ${limit}
      OFFSET ${offset}
    `;
  } else {
    query = sql`
      SELECT
        id, scientific_name, common_names, plant_family,
        hardiness_zone_min, hardiness_zone_max,
        growth_habit, stratification_layer, mature_height_cm,
        sun_requirements, water_needs, nitrogen_fixer,
        edible_parts, pollinator_attractant, wildlife_value
      FROM plants
      ORDER BY scientific_name
      LIMIT ${limit}
      OFFSET ${offset}
    `;
  }

  const plants = await query;

  // Get total count
  let countQuery;
  if (conditions.length > 0) {
    countQuery = sql`SELECT COUNT(*) as total FROM plants WHERE ${sql(conditions, ' AND ')}`;
  } else {
    countQuery = sql`SELECT COUNT(*) as total FROM plants`;
  }

  const [{ total }] = await countQuery;

  return json({
    plants,
    total: parseInt(total),
    limit,
    offset,
  });
};
