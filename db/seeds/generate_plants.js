/**
 * Plant Registry Generator - Creates 10,000 botanical entries
 * Combines real botanical data with systematic generation
 */

const fs = require('fs');

// Real plant families with common genera
const botanicalData = [
  // Trees
  { family: 'Rosaceae', genera: ['Malus', 'Prunus', 'Pyrus', 'Crataegus', 'Sorbus'], habit: 'tree', layer: 'canopy' },
  { family: 'Fagaceae', genera: ['Quercus', 'Fagus', 'Castanea', 'Nothofagus'], habit: 'tree', layer: 'emergent' },
  { family: 'Pinaceae', genera: ['Pinus', 'Picea', 'Abies', 'Larix', 'Tsuga', 'Cedrus'], habit: 'tree', layer: 'emergent' },
  { family: 'Aceraceae', genera: ['Acer'], habit: 'tree', layer: 'canopy' },
  { family: 'Juglandaceae', genera: ['Juglans', 'Carya', 'Pterocarya'], habit: 'tree', layer: 'emergent' },
  { family: 'Betulaceae', genera: ['Betula', 'Alnus', 'Corylus', 'Carpinus'], habit: 'tree', layer: 'canopy' },
  { family: 'Salicaceae', genera: ['Salix', 'Populus'], habit: 'tree', layer: 'canopy' },
  { family: 'Fabaceae', genera: ['Robinia', 'Gleditsia', 'Acacia', 'Albizia'], habit: 'tree', layer: 'canopy', nitrogen_fixer: true },
  { family: 'Moraceae', genera: ['Ficus', 'Morus'], habit: 'tree', layer: 'sub-canopy' },
  { family: 'Oleaceae', genera: ['Fraxinus', 'Olea'], habit: 'tree', layer: 'canopy' },

  // Shrubs & Bushes
  { family: 'Ericaceae', genera: ['Vaccinium', 'Rhododendron', 'Arbutus', 'Arctostaphylos'], habit: 'shrub', layer: 'shrub' },
  { family: 'Rosaceae', genera: ['Rubus', 'Rosa', 'Spiraea', 'Amelanchier'], habit: 'shrub', layer: 'shrub' },
  { family: 'Caprifoliaceae', genera: ['Sambucus', 'Viburnum', 'Lonicera'], habit: 'shrub', layer: 'shrub' },
  { family: 'Elaeagnaceae', genera: ['Elaeagnus', 'Hippophae', 'Shepherdia'], habit: 'shrub', layer: 'shrub', nitrogen_fixer: true },

  // Herbs & Vegetables
  { family: 'Lamiaceae', genera: ['Mentha', 'Thymus', 'Origanum', 'Salvia', 'Lavandula', 'Rosmarinus'], habit: 'herb', layer: 'herbaceous' },
  { family: 'Asteraceae', genera: ['Lactuca', 'Taraxacum', 'Helianthus', 'Artemisia', 'Achillea'], habit: 'herb', layer: 'herbaceous' },
  { family: 'Apiaceae', genera: ['Daucus', 'Petroselinum', 'Coriandrum', 'Foeniculum', 'Angelica'], habit: 'herb', layer: 'herbaceous' },
  { family: 'Brassicaceae', genera: ['Brassica', 'Raphanus', 'Armoracia'], habit: 'herb', layer: 'herbaceous' },
  { family: 'Solanaceae', genera: ['Solanum', 'Capsicum', 'Physalis'], habit: 'herb', layer: 'herbaceous' },
  { family: 'Cucurbitaceae', genera: ['Cucurbita', 'Cucumis', 'Citrullus'], habit: 'vine', layer: 'vertical' },
  { family: 'Fabaceae', genera: ['Trifolium', 'Vicia', 'Medicago', 'Pisum', 'Phaseolus'], habit: 'herb', layer: 'ground', nitrogen_fixer: true },
  { family: 'Amaryllidaceae', genera: ['Allium'], habit: 'herb', layer: 'herbaceous' },
  { family: 'Poaceae', genera: ['Zea', 'Triticum', 'Avena', 'Hordeum', 'Panicum'], habit: 'grass', layer: 'herbaceous' },

  // Groundcovers
  { family: 'Fragaria', genera: ['Fragaria'], habit: 'groundcover', layer: 'ground' },
  { family: 'Thymus', genera: ['Thymus'], habit: 'groundcover', layer: 'ground' },
];

// Species suffixes
const speciesSuffixes = [
  'vulgaris', 'communis', 'officinalis', 'sativa', 'sylvestris', 'arvensis',
  'pratensis', 'maritima', 'montana', 'alpina', 'occidentalis', 'orientalis',
  'americana', 'europaea', 'asiatica', 'australis', 'borealis', 'meridionalis',
  'major', 'minor', 'nigra', 'alba', 'rubra', 'viridis', 'purpurea', 'aurea',
  'grandiflora', 'parviflora', 'longifolia', 'latifolia', 'angustifolia',
  'tomentosa', 'glabra', 'hirsuta', 'pubescens', 'repens', 'erecta'
];

// Cultivar suffixes for varieties
const cultivars = [
  'Early', 'Late', 'Dwarf', 'Giant', 'Golden', 'Silver', 'Purple', 'Crimson',
  'Sweet', 'Wild', 'Hardy', 'Tender', 'Compact', 'Spreading', 'Upright',
  'Northern', 'Southern', 'Mountain', 'Valley', 'Coastal', 'Desert'
];

// Generate random zone range
function generateZoneRange() {
  const min = Math.floor(Math.random() * 9) + 1; // 1-9
  const max = Math.min(min + Math.floor(Math.random() * 5) + 2, 13); // up to 13
  return [min, max];
}

// Generate plant characteristics based on habit
function getCharacteristics(habit, layer, family) {
  const characteristics = {
    tree: {
      height: [300, 3500],
      width: [200, 2500],
      lifespan: [30, 200],
      maturity: [5, 15],
    },
    shrub: {
      height: [100, 600],
      width: [80, 500],
      lifespan: [10, 50],
      maturity: [2, 5],
    },
    herb: {
      height: [20, 150],
      width: [15, 100],
      lifespan: [1, 15],
      maturity: [0, 2],
    },
    vine: {
      height: [100, 800],
      width: [50, 200],
      lifespan: [1, 30],
      maturity: [1, 3],
    },
    groundcover: {
      height: [5, 40],
      width: [30, 150],
      lifespan: [3, 20],
      maturity: [0, 2],
    },
    grass: {
      height: [30, 300],
      width: [20, 100],
      lifespan: [1, 10],
      maturity: [0, 1],
    },
  };

  const char = characteristics[habit] || characteristics.herb;
  return {
    height: Math.floor(Math.random() * (char.height[1] - char.height[0]) + char.height[0]),
    width: Math.floor(Math.random() * (char.width[1] - char.width[0]) + char.width[0]),
    lifespan: Math.floor(Math.random() * (char.lifespan[1] - char.lifespan[0]) + char.lifespan[0]),
    maturity: Math.floor(Math.random() * (char.maturity[1] - char.maturity[0]) + char.maturity[0]),
  };
}

// Get sun requirements
function getSunRequirements() {
  const options = ['full', 'partial', 'shade', 'any'];
  return options[Math.floor(Math.random() * options.length)];
}

// Get soil drainage
function getSoilDrainage() {
  const options = ['well-drained', 'moist', 'wet', 'any'];
  return options[Math.floor(Math.random() * options.length)];
}

// Get water needs
function getWaterNeeds() {
  const options = ['low', 'medium', 'high'];
  return options[Math.floor(Math.random() * options.length)];
}

// Get succession stage
function getSuccessionStage(layer) {
  if (layer === 'emergent' || layer === 'canopy') {
    return ['pioneer', 'secondary', 'climax'][Math.floor(Math.random() * 3)];
  } else if (layer === 'ground' || layer === 'herbaceous') {
    return ['pioneer', 'secondary'][Math.floor(Math.random() * 2)];
  }
  return 'secondary';
}

// Get mycorrhizal type
function getMycorrhizalType(habit, family) {
  if (family === 'Pinaceae' || family === 'Fagaceae' || family === 'Betulaceae') {
    return 'ecto';
  } else if (habit === 'tree' && Math.random() > 0.5) {
    return 'ecto';
  } else {
    return 'endo';
  }
}

// Generate edible parts
function getEdibleParts(habit, family) {
  const parts = [];
  if (family === 'Rosaceae' && habit === 'tree') {
    parts.push('fruit');
  } else if (family === 'Juglandaceae' || family === 'Fagaceae') {
    parts.push('nuts');
  } else if (family === 'Lamiaceae' || family === 'Apiaceae') {
    parts.push('leaves');
  } else if (family === 'Brassicaceae') {
    parts.push('leaves', 'roots');
  } else if (family === 'Solanaceae' || family === 'Cucurbitaceae') {
    parts.push('fruit');
  } else if (family === 'Fabaceae' && habit === 'herb') {
    parts.push('seeds', 'pods');
  } else if (Math.random() > 0.7) {
    const options = ['leaves', 'roots', 'flowers', 'stems'];
    parts.push(options[Math.floor(Math.random() * options.length)]);
  }
  return parts;
}

// Generate SQL INSERT statements
function generatePlantSQL(count = 10000) {
  let sql = '-- Generated plant database with 10,000 entries\n\n';
  const usedNames = new Set();
  let generatedCount = 0;

  while (generatedCount < count) {
    const familyData = botanicalData[Math.floor(Math.random() * botanicalData.length)];
    const genus = familyData.genera[Math.floor(Math.random() * familyData.genera.length)];
    const species = speciesSuffixes[Math.floor(Math.random() * speciesSuffixes.length)];
    const variety = Math.random() > 0.7 ? ` var. ${speciesSuffixes[Math.floor(Math.random() * speciesSuffixes.length)]}` : '';
    const scientificName = `${genus} ${species}${variety}`;

    // Skip duplicates
    if (usedNames.has(scientificName)) continue;
    usedNames.add(scientificName);

    const commonName = `${cultivars[Math.floor(Math.random() * cultivars.length)]} ${genus}`;
    const [zoneMin, zoneMax] = generateZoneRange();
    const char = getCharacteristics(familyData.habit, familyData.layer, familyData.family);
    const soilPh = [5.5 + Math.random() * 1.5, 6.5 + Math.random() * 1.5];
    const nitrogenFixer = familyData.nitrogen_fixer || false;
    const edibleParts = getEdibleParts(familyData.habit, familyData.family);
    const pollinatorAttractant = Math.random() > 0.4;
    const mycorrhizalType = getMycorrhizalType(familyData.habit, familyData.family);
    const wildlifeValue = Math.floor(Math.random() * 10) + 1;

    // Dynamic accumulators for certain families
    const dynamicAccumulators = [];
    if (familyData.family === 'Fabaceae' && nitrogenFixer) {
      dynamicAccumulators.push('nitrogen');
    }
    if (familyData.family === 'Boraginaceae') {
      dynamicAccumulators.push('nitrogen', 'phosphorus', 'potassium');
    }

    sql += `INSERT INTO plants (
  scientific_name, common_names, plant_family, hardiness_zone_min, hardiness_zone_max,
  growth_habit, mature_height_cm, mature_width_cm, stratification_layer, succession_stage,
  lifespan_years, time_to_maturity_years, sun_requirements, soil_ph_min, soil_ph_max,
  soil_drainage, water_needs, nitrogen_fixer, ${dynamicAccumulators.length > 0 ? 'dynamic_accumulator,' : ''}
  ${edibleParts.length > 0 ? 'edible_parts,' : ''} pollinator_attractant, mycorrhizal_type, wildlife_value
) VALUES (
  '${scientificName}',
  ARRAY['${commonName}'],
  '${familyData.family}',
  ${zoneMin}, ${zoneMax},
  '${familyData.habit}',
  ${char.height}, ${char.width},
  '${familyData.layer}',
  '${getSuccessionStage(familyData.layer)}',
  ${char.lifespan}, ${char.maturity},
  '${getSunRequirements()}',
  ${soilPh[0].toFixed(1)}, ${soilPh[1].toFixed(1)},
  '${getSoilDrainage()}',
  '${getWaterNeeds()}',
  ${nitrogenFixer},
  ${dynamicAccumulators.length > 0 ? `ARRAY['${dynamicAccumulators.join("','")}'],` : ''}
  ${edibleParts.length > 0 ? `ARRAY['${edibleParts.join("','")}'],` : ''}
  ${pollinatorAttractant},
  '${mycorrhizalType}',
  ${wildlifeValue}
);\n`;

    generatedCount++;

    if (generatedCount % 100 === 0) {
      console.log(`Generated ${generatedCount} plants...`);
    }
  }

  return sql;
}

console.log('Generating 10,000 plant database entries...');
const sql = generatePlantSQL(10000);
fs.writeFileSync('/mnt/c/Users/Samuel/Downloads/Projects/syntropy-calculator/db/seeds/03-large-plant-registry.sql', sql);
console.log('✓ Successfully generated 10,000 plant entries!');
console.log('  File: db/seeds/03-large-plant-registry.sql');
