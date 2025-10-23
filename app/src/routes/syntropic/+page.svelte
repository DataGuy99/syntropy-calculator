<script lang="ts">
  let zone = 7;
  let size_sqft = 2000;
  let sun_exposure = 'full';
  let water_availability = 'medium';
  let soil_ph = 6.5;
  let primary_purpose = 'food';
  let years_to_plan = 20;
  let loading = false;
  let guild: any = null;

  async function generateGuild() {
    loading = true;
    try {
      const response = await fetch('/api/guilds/syntropic', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          zone,
          size_sqft,
          sun_exposure,
          water_availability,
          soil_ph,
          primary_purpose,
          years_to_plan,
        }),
      });

      if (!response.ok) {
        throw new Error('Failed to generate guild');
      }

      guild = await response.json();
    } catch (err) {
      console.error(err);
      alert('Failed to generate syntropic guild');
    } finally {
      loading = false;
    }
  }
</script>

<svelte:head>
  <title>Syntropic Agroforestry Builder - Syntropy Calculator</title>
</svelte:head>

<div class="container">
  <header>
    <h1>🌳 Syntropic Agroforestry Designer</h1>
    <p>Multi-phase succession guilds based on Ernst Götsch methodology</p>
    <div class="nav-links">
      <a href="/">← Plant Database</a>
      <a href="/guild-builder">← Basic Guild Builder</a>
    </div>
  </header>

  <div class="content">
    <section class="builder-section">
      <h2>Guild Parameters</h2>

      <div class="form-grid">
        <div class="form-field">
          <label for="zone">USDA Hardiness Zone</label>
          <select id="zone" bind:value={zone}>
            {#each Array.from({ length: 13 }, (_, i) => i + 1) as z}
              <option value={z}>Zone {z}</option>
            {/each}
          </select>
        </div>

        <div class="form-field">
          <label for="size">Size (square feet)</label>
          <input id="size" type="number" bind:value={size_sqft} min="500" step="100" />
        </div>

        <div class="form-field">
          <label for="years">Planning Horizon (years)</label>
          <input id="years" type="number" bind:value={years_to_plan} min="5" max="50" />
        </div>

        <div class="form-field">
          <label for="sun">Sun Exposure</label>
          <select id="sun" bind:value={sun_exposure}>
            <option value="full">Full Sun</option>
            <option value="partial">Partial Shade</option>
            <option value="shade">Shade</option>
          </select>
        </div>

        <div class="form-field">
          <label for="water">Water Availability</label>
          <select id="water" bind:value={water_availability}>
            <option value="low">Low (Drought/Minimal irrigation)</option>
            <option value="medium">Medium (Regular irrigation)</option>
            <option value="high">High (Consistent moisture)</option>
          </select>
        </div>

        <div class="form-field">
          <label for="ph">Soil pH (optional)</label>
          <input id="ph" type="number" bind:value={soil_ph} min="4" max="9" step="0.1" />
        </div>

        <div class="form-field full-width">
          <label for="purpose">Primary Purpose</label>
          <select id="purpose" bind:value={primary_purpose}>
            <option value="food">Food Production</option>
            <option value="restoration">Soil Restoration</option>
            <option value="biodiversity">Biodiversity Enhancement</option>
            <option value="wildlife">Wildlife Habitat</option>
            <option value="carbon">Carbon Sequestration</option>
            <option value="timber">Timber/Biomass Production</option>
          </select>
        </div>
      </div>

      <button class="generate-btn" on:click={generateGuild} disabled={loading}>
        {loading ? 'Generating Syntropic Guild...' : '🌿 Generate Syntropic Guild'}
      </button>
    </section>

    {#if guild}
      <section class="results-section">
        <h2>{guild.name}</h2>
        <p class="description">{guild.description}</p>

        <div class="guild-overview">
          <div class="overview-card">
            <h3>Total Plants</h3>
            <p class="stat">{guild.total_plants}</p>
          </div>
          <div class="overview-card">
            <h3>Timeline</h3>
            <p>{guild.succession_timeline}</p>
          </div>
        </div>

        <div class="strategy-section">
          <div class="strategy-card">
            <h3>🌱 Biomass Production Strategy</h3>
            <p>{guild.biomass_production_strategy}</p>
          </div>
          <div class="strategy-card">
            <h3>♻️ Nutrient Cycling Plan</h3>
            <p>{guild.nutrient_cycling_plan}</p>
          </div>
        </div>

        <h3 class="section-title">Succession Phases</h3>
        {#each guild.succession_phases as phase}
          <div class="phase-card">
            <div class="phase-header">
              <h4>{phase.phase} <span class="phase-years">({phase.years})</span></h4>
              <p class="phase-goals"><strong>Goals:</strong> {phase.goals}</p>
            </div>

            <div class="phase-management">
              <strong>Management:</strong> {phase.management}
            </div>

            <div class="plants-grid">
              {#each phase.plants as plantRec}
                <div class="plant-card-syn">
                  <div class="plant-header">
                    <h5>{plantRec.plant.scientific_name}</h5>
                    <span class="plant-common">{plantRec.plant.common_names?.join(', ')}</span>
                  </div>

                  <div class="plant-details">
                    <div class="detail-row">
                      <strong>Role:</strong> {plantRec.role}
                    </div>
                    <div class="detail-row">
                      <strong>Planting:</strong> Year {plantRec.planting_year} |
                      {plantRec.quantity} plants @ {plantRec.spacing_cm}cm spacing
                    </div>
                    {#if plantRec.pruning_schedule}
                      <div class="detail-row pruning">
                        <strong>Pruning:</strong> {plantRec.pruning_schedule}
                      </div>
                    {/if}
                    {#if plantRec.nutrient_accumulation?.length > 0}
                      <div class="detail-row nutrients">
                        <strong>Accumulates:</strong> {plantRec.nutrient_accumulation.join(', ')}
                      </div>
                    {/if}
                    <div class="management-notes">
                      💡 {plantRec.management_notes}
                    </div>
                  </div>

                  <div class="plant-badges">
                    {#if plantRec.plant.nitrogen_fixer}
                      <span class="badge nitrogen">N-Fixer</span>
                    {/if}
                    {#if plantRec.plant.dynamic_accumulator?.length > 0}
                      <span class="badge accumulator">Dynamic Accumulator</span>
                    {/if}
                    {#if plantRec.plant.edible_parts?.length > 0}
                      <span class="badge edible">Edible</span>
                    {/if}
                    {#if plantRec.plant.biomass_production === 'very-high'}
                      <span class="badge biomass">High Biomass</span>
                    {/if}
                  </div>
                </div>
              {/each}
            </div>
          </div>
        {/each}

        <div class="calendar-section">
          <h3 class="section-title">📅 Maintenance Calendar</h3>
          <div class="calendar-grid">
            {#each guild.maintenance_calendar as period}
              <div class="calendar-card">
                <h4>{period.month}</h4>
                <ul>
                  {#each period.tasks as task}
                    <li>{task}</li>
                  {/each}
                </ul>
              </div>
            {/each}
          </div>
        </div>
      </section>
    {/if}
  </div>
</div>

<style>
  :global(body) {
    margin: 0;
    padding: 0;
    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
    background: linear-gradient(135deg, #10b981 0%, #059669 100%);
    min-height: 100vh;
  }

  .container {
    max-width: 1600px;
    margin: 0 auto;
    padding: 2rem;
  }

  header {
    text-align: center;
    color: white;
    margin-bottom: 3rem;
  }

  header h1 {
    font-size: 3rem;
    margin: 0;
  }

  header p {
    font-size: 1.2rem;
    opacity: 0.95;
    margin-top: 0.5rem;
  }

  .nav-links {
    display: flex;
    gap: 1.5rem;
    justify-content: center;
    margin-top: 1rem;
  }

  .nav-links a {
    color: white;
    text-decoration: none;
    opacity: 0.9;
    transition: opacity 0.3s;
  }

  .nav-links a:hover {
    opacity: 1;
  }

  .builder-section,
  .results-section {
    background: white;
    border-radius: 1rem;
    padding: 2rem;
    box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
    margin-bottom: 2rem;
  }

  h2 {
    margin-top: 0;
    color: #065f46;
  }

  .form-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
    gap: 1.5rem;
    margin-bottom: 2rem;
  }

  .full-width {
    grid-column: 1 / -1;
  }

  .form-field label {
    display: block;
    font-weight: 600;
    margin-bottom: 0.5rem;
    color: #065f46;
  }

  .form-field input,
  .form-field select {
    width: 100%;
    padding: 0.75rem;
    border: 2px solid #d1fae5;
    border-radius: 0.5rem;
    font-size: 1rem;
    transition: border-color 0.3s;
  }

  .form-field input:focus,
  .form-field select:focus {
    outline: none;
    border-color: #10b981;
  }

  .generate-btn {
    width: 100%;
    background: linear-gradient(135deg, #10b981 0%, #059669 100%);
    color: white;
    border: none;
    padding: 1.25rem;
    font-size: 1.2rem;
    font-weight: 600;
    border-radius: 0.75rem;
    cursor: pointer;
    transition: transform 0.2s;
  }

  .generate-btn:hover:not(:disabled) {
    transform: translateY(-2px);
  }

  .generate-btn:disabled {
    opacity: 0.6;
    cursor: not-allowed;
  }

  .description {
    color: #6b7280;
    font-size: 1.1rem;
    margin-bottom: 2rem;
    line-height: 1.6;
  }

  .guild-overview {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
    gap: 1.5rem;
    margin-bottom: 2rem;
  }

  .overview-card {
    background: #f0fdf4;
    padding: 1.5rem;
    border-radius: 0.75rem;
    border-left: 4px solid #10b981;
  }

  .overview-card h3 {
    margin: 0 0 0.5rem 0;
    color: #065f46;
    font-size: 0.9rem;
    text-transform: uppercase;
  }

  .stat {
    font-size: 2.5rem;
    font-weight: 700;
    color: #059669;
    margin: 0;
  }

  .strategy-section {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(400px, 1fr));
    gap: 1.5rem;
    margin-bottom: 2rem;
  }

  .strategy-card {
    background: #ecfdf5;
    padding: 1.5rem;
    border-radius: 0.75rem;
  }

  .strategy-card h3 {
    margin-top: 0;
    color: #065f46;
    font-size: 1.1rem;
  }

  .section-title {
    color: #065f46;
    font-size: 1.5rem;
    margin: 2rem 0 1rem 0;
    padding-bottom: 0.5rem;
    border-bottom: 3px solid #10b981;
  }

  .phase-card {
    background: #f9fafb;
    border-radius: 0.75rem;
    padding: 2rem;
    margin-bottom: 2rem;
    border: 2px solid #10b981;
  }

  .phase-header h4 {
    margin: 0;
    color: #059669;
    font-size: 1.5rem;
  }

  .phase-years {
    color: #6b7280;
    font-weight: normal;
    font-size: 1rem;
  }

  .phase-goals {
    color: #374151;
    margin: 0.5rem 0 1rem 0;
  }

  .phase-management {
    background: #ecfdf5;
    padding: 1rem;
    border-radius: 0.5rem;
    margin-bottom: 1.5rem;
    color: #065f46;
  }

  .plants-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
    gap: 1.5rem;
  }

  .plant-card-syn {
    background: white;
    border: 2px solid #d1fae5;
    border-radius: 0.75rem;
    padding: 1.5rem;
    transition: transform 0.2s, box-shadow 0.2s;
  }

  .plant-card-syn:hover {
    transform: translateY(-3px);
    box-shadow: 0 5px 20px rgba(16, 185, 129, 0.2);
  }

  .plant-header h5 {
    margin: 0 0 0.25rem 0;
    color: #065f46;
    font-style: italic;
  }

  .plant-common {
    color: #6b7280;
    font-size: 0.9rem;
  }

  .plant-details {
    margin: 1rem 0;
  }

  .detail-row {
    margin: 0.5rem 0;
    color: #374151;
    font-size: 0.9rem;
  }

  .detail-row.pruning {
    background: #fef3c7;
    padding: 0.5rem;
    border-radius: 0.25rem;
  }

  .detail-row.nutrients {
    background: #dbeafe;
    padding: 0.5rem;
    border-radius: 0.25rem;
  }

  .management-notes {
    background: #f0fdf4;
    padding: 0.75rem;
    border-radius: 0.5rem;
    margin-top: 1rem;
    font-size: 0.9rem;
    color: #065f46;
    border-left: 3px solid #10b981;
  }

  .plant-badges {
    display: flex;
    flex-wrap: wrap;
    gap: 0.5rem;
    margin-top: 1rem;
  }

  .badge {
    display: inline-block;
    padding: 0.25rem 0.75rem;
    border-radius: 1rem;
    font-size: 0.75rem;
    font-weight: 600;
  }

  .badge.nitrogen {
    background: #c6f6d5;
    color: #22543d;
  }

  .badge.accumulator {
    background: #dbeafe;
    color: #1e40af;
  }

  .badge.edible {
    background: #fed7d7;
    color: #742a2a;
  }

  .badge.biomass {
    background: #fef3c7;
    color: #78350f;
  }

  .calendar-section {
    margin-top: 3rem;
  }

  .calendar-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
    gap: 1.5rem;
  }

  .calendar-card {
    background: #f0fdf4;
    border-radius: 0.75rem;
    padding: 1.5rem;
    border-left: 4px solid #10b981;
  }

  .calendar-card h4 {
    margin: 0 0 1rem 0;
    color: #065f46;
  }

  .calendar-card ul {
    margin: 0;
    padding-left: 1.5rem;
  }

  .calendar-card li {
    color: #374151;
    margin: 0.5rem 0;
  }
</style>
