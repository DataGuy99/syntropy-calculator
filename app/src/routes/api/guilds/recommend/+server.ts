import { json, error } from '@sveltejs/kit';
import { generateGuildRecommendation } from '$lib/server/guildRecommendation';
import type { RequestHandler } from './$types';

export const POST: RequestHandler = async ({ request }) => {
  try {
    const params = await request.json();

    const { zone, size_sqft, sun_exposure, water_availability, soil_ph, primary_purpose } = params;

    if (!zone || !size_sqft || !sun_exposure || !water_availability || !primary_purpose) {
      throw error(400, 'Missing required parameters');
    }

    if (zone < 1 || zone > 13) {
      throw error(400, 'Zone must be between 1 and 13');
    }

    if (size_sqft <= 0) {
      throw error(400, 'Size must be greater than 0');
    }

    const guild = await generateGuildRecommendation({
      zone: parseInt(zone),
      size_sqft: parseFloat(size_sqft),
      sun_exposure,
      water_availability,
      soil_ph: soil_ph ? parseFloat(soil_ph) : undefined,
      primary_purpose,
    });

    return json(guild);
  } catch (err) {
    console.error('Guild recommendation error:', err);
    throw error(500, 'Failed to generate guild recommendation');
  }
};
