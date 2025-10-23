import { json, error } from '@sveltejs/kit';
import { sql } from '$lib/server/db';
import type { RequestHandler } from './$types';

export const GET: RequestHandler = async ({ params }) => {
  const plantId = parseInt(params.id);

  if (isNaN(plantId)) {
    throw error(400, 'Invalid plant ID');
  }

  const [plant] = await sql`
    SELECT * FROM plants WHERE id = ${plantId}
  `;

  if (!plant) {
    throw error(404, 'Plant not found');
  }

  // Get companion plants
  const companions = await sql`
    SELECT
      p.id, p.scientific_name, p.common_names,
      pc.relationship_type, pc.notes
    FROM plant_companions pc
    JOIN plants p ON p.id = pc.companion_id
    WHERE pc.plant_id = ${plantId}
  `;

  // Get fungi associations
  const fungi = await sql`
    SELECT
      f.id, f.scientific_name, f.common_name,
      pf.association_strength
    FROM plant_fungi pf
    JOIN fungi f ON f.id = pf.fungi_id
    WHERE pf.plant_id = ${plantId}
  `;

  return json({
    plant,
    companions,
    fungi,
  });
};
