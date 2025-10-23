# 🌳 Syntropy Calculator

**Syntropic Agroforestry Guild Designer** - Intelligent plant guild recommendations based on Ernst Götsch's methodology and permaculture principles.

![Version](https://img.shields.io/badge/version-0.3.0-green)
![License](https://img.shields.io/badge/license-MIT-blue)

## 🌿 Features

- **10,015+ Plant Database** - Comprehensive botanical registry with real families and species
- **Syntropic Agroforestry Designer** - 4-phase succession planning (Colonization → Accumulation → Consolidation → Abundance)
- **Guild Builder** - Smart companion planting and stratified layer design
- **Chop-and-Drop Management** - Biomass production and pruning schedules
- **Nutrient Cycling** - Dynamic accumulators and nitrogen fixers
- **Ecological Interactions** - Mycorrhizal networks, pest deterrents, nurse plants

## 🚀 Tech Stack

- **Frontend**: SvelteKit + TypeScript
- **Database**: PostgreSQL 16 with PostGIS
- **Deployment**: Netlify
- **Development**: Docker

## 📦 Quick Start

### Local Development

```bash
# Clone the repository
git clone https://github.com/DataGuy99/syntropy-calculator.git
cd syntropy-calculator

# Start PostgreSQL database
docker-compose up -d

# Install dependencies and run dev server
cd app
npm install
npm run dev
```

Visit `http://localhost:5173`

### Database Setup

The database automatically initializes with:
- Complete schema (plants, fungi, guilds, companions)
- 10,015 plant entries
- 11 beneficial fungi species
- Syntropic succession data
- Sample guilds

## 🌱 Syntropic Methodology

Based on **Ernst Götsch's** syntropic agroforestry principles:

1. **Colonization (Year 0-2)** - Fast-growing pioneers and nitrogen fixers
2. **Accumulation (Year 1-5)** - Dynamic accumulators building soil
3. **Consolidation (Year 2-15)** - Productive fruit/nut trees
4. **Abundance (Year 5-50+)** - Mature food forest ecosystem

## 📊 Database Contents

- **Plants**: 10,015 entries across 23 botanical families
- **Succession Stages**: 6,226 syntropic phase assignments
- **Nutrient Data**: Complete accumulator tracking
- **Ecological Interactions**: 7+ relationship types
- **Pruning Schedules**: Chop-and-drop strategies

## 🎯 Use Cases

- Professional permaculture design
- Food forest planning
- Soil restoration projects
- Carbon sequestration initiatives
- Regenerative agriculture
- Educational demonstrations

## 📝 Pages

- `/` - Plant database browser (10k+ searchable plants)
- `/guild-builder` - Basic guild recommendations
- `/syntropic` - **Advanced syntropic agroforestry designer**

## 🔧 Environment Variables

Required for deployment:

```env
DATABASE_URL=postgresql://user:password@host:5432/database
PUBLIC_APP_NAME=Syntropy Calculator
NODE_ENV=production
```

## 🤝 Contributing

This is an open-source permaculture tool. Contributions welcome!

## 📄 License

MIT License - Free for educational and commercial use

## 🙏 Acknowledgments

- Ernst Götsch - Syntropic agroforestry methodology
- Bill Mollison & David Holmgren - Permaculture principles
- Toby Hemenway - "Gaia's Garden"

---

Built with 🌱 by Claude Code
