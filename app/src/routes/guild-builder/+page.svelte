<script lang="ts">
  let zone = 7;
  let size_sqft = 1000;
  let sun_exposure = 'full';
  let water_availability = 'medium';
  let soil_ph = 6.5;
  let primary_purpose = 'food';
  let loading = false;
  let guild: any = null;

  async function generateGuild() {
    loading = true;
    try {
      const response = await fetch('/api/guilds/recommend', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          zone,
          size_sqft,
          sun_exposure,
          water_availability,
          soil_ph,
          primary_purpose,
        }),
      });

      if (!response.ok) {
        throw new Error('Failed to generate guild');
      }

      guild = await response.json();
    } catch (err) {
      console.error(err);
      alert('Failed to generate guild recommendation');
    } finally {
      loading = false;
    }
  }
</script>

<svelte:head>
  <title>Guild Builder - Syntropy Calculator</title>
</svelte:head>

<div class="container">
  <header>
    <h1>🌳 Guild Builder</h1>
    <p>Design your syntropic agroforestry guild</p>
    <a href="/" class="back-link">← Back to Plant Database</a>
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
          <input id="size" type="number" bind:value={size_sqft} min="100" step="50" />
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
            <option value="low">Low (Drought conditions)</option>
            <option value="medium">Medium (Regular irrigation)</option>
            <option value="high">High (Consistent moisture)</option>
          </select>
        </div>

        <div class="form-field">
          <label for="ph">Soil pH (optional)</label>
          <input id="ph" type="number" bind:value={soil_ph} min="4" max="9" step="0.1" />
        </div>

        <div class="form-field">
          <label for="purpose">Primary Purpose</label>
          <select id="purpose" bind:value={primary_purpose}>
            <option value="food">Food Production</option>
            <option value="biodiversity">Biodiversity</option>
            <option value="wildlife">Wildlife Habitat</option>
            <option value="carbon">Carbon Sequestration</option>
            <option value="timber">Timber Production</option>
            <option value="erosion-control">Erosion Control</option>
          </select>
        </div>
      </div>

      <button class="generate-btn" on:click={generateGuild} disabled={loading}>
        {loading ? 'Generating...' : '🌿 Generate Guild'}
      </button>
    </section>

    {#if guild}
      <section class="results-section">
        <h2>{guild.name}</h2>

        <div class="guild-stats">
          <div class="stat">
            <span class="stat-label">Total Plants</span>
            <span class="stat-value">{guild.total_plants}</span>
          </div>
          <div class="stat">
            <span class="stat-label">Maintenance</span>
            <span class="stat-value maintenance-{guild.maintenance_level}">
              {guild.maintenance_level}
            </span>
          </div>
        </div>

        <div class="timeline">
          <h3>Succession Timeline</h3>
          <p>{guild.succession_timeline}</p>
        </div>

        <div class="layers">
          <h3>Stratification Layers</h3>
          {#each guild.layers as layer}
            <div class="layer-card">
              <div class="layer-header">
                <h4>{layer.layer}</h4>
                <span class="layer-quantity">{layer.quantity} plants @ {layer.spacing_cm}cm spacing</span>
              </div>

              <div class="layer-plants">
                {#each layer.plants as plant}
                  <div class="plant-item">
                    <div class="plant-name">{plant.scientific_name}</div>
                    <div class="plant-common">
                      {plant.common_names.join(', ')}
                    </div>
                    <div class="plant-badges">
                      {#if plant.nitrogen_fixer}
                        <span class="badge nitrogen">N-Fixer</span>
                      {/if}
                      {#if plant.pollinator_attractant}
                        <span class="badge pollinator">🐝</span>
                      {/if}
                      {#if plant.edible_parts?.length > 0}
                        <span class="badge edible">🍽️</span>
                      {/if}
                    </div>
                  </div>
                {/each}
              </div>
            </div>
          {/each}
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
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    min-height: 100vh;
  }

  .container {
    max-width: 1400px;
    margin: 0 auto;
    padding: 2rem;
  }

  header {
    text-align: center;
    color: white;
    margin-bottom: 3rem;
    position: relative;
  }

  header h1 {
    font-size: 3rem;
    margin: 0;
  }

  header p {
    font-size: 1.2rem;
    opacity: 0.9;
  }

  .back-link {
    position: absolute;
    top: 0;
    left: 0;
    color: white;
    text-decoration: none;
    font-size: 1rem;
    opacity: 0.8;
    transition: opacity 0.3s;
  }

  .back-link:hover {
    opacity: 1;
  }

  .content {
    display: grid;
    gap: 2rem;
  }

  .builder-section,
  .results-section {
    background: white;
    border-radius: 1rem;
    padding: 2rem;
    box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
  }

  h2 {
    margin-top: 0;
    color: #333;
  }

  .form-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
    gap: 1.5rem;
    margin-bottom: 2rem;
  }

  .form-field label {
    display: block;
    font-weight: 600;
    margin-bottom: 0.5rem;
    color: #555;
  }

  .form-field input,
  .form-field select {
    width: 100%;
    padding: 0.75rem;
    border: 2px solid #e0e0e0;
    border-radius: 0.5rem;
    font-size: 1rem;
    transition: border-color 0.3s;
  }

  .form-field input:focus,
  .form-field select:focus {
    outline: none;
    border-color: #667eea;
  }

  .generate-btn {
    width: 100%;
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
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

  .guild-stats {
    display: flex;
    gap: 2rem;
    margin: 1.5rem 0;
  }

  .stat {
    display: flex;
    flex-direction: column;
    gap: 0.5rem;
  }

  .stat-label {
    font-size: 0.875rem;
    color: #666;
    text-transform: uppercase;
    font-weight: 600;
  }

  .stat-value {
    font-size: 2rem;
    font-weight: 700;
    color: #333;
  }

  .maintenance-low {
    color: #22c55e;
  }

  .maintenance-medium {
    color: #f59e0b;
  }

  .maintenance-high {
    color: #ef4444;
  }

  .timeline {
    background: #f0f9ff;
    border-left: 4px solid #667eea;
    padding: 1.5rem;
    margin: 2rem 0;
    border-radius: 0.5rem;
  }

  .timeline h3 {
    margin-top: 0;
    color: #667eea;
  }

  .layers {
    margin-top: 2rem;
  }

  .layer-card {
    border: 2px solid #e0e0e0;
    border-radius: 0.75rem;
    padding: 1.5rem;
    margin-bottom: 1.5rem;
    transition: border-color 0.3s;
  }

  .layer-card:hover {
    border-color: #667eea;
  }

  .layer-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 1rem;
    padding-bottom: 1rem;
    border-bottom: 2px solid #e0e0e0;
  }

  .layer-header h4 {
    margin: 0;
    color: #667eea;
    text-transform: capitalize;
  }

  .layer-quantity {
    font-size: 0.875rem;
    color: #666;
    font-weight: 600;
  }

  .layer-plants {
    display: grid;
    gap: 1rem;
  }

  .plant-item {
    display: grid;
    gap: 0.25rem;
    padding: 1rem;
    background: #f9fafb;
    border-radius: 0.5rem;
  }

  .plant-name {
    font-style: italic;
    font-weight: 600;
    color: #333;
  }

  .plant-common {
    font-size: 0.875rem;
    color: #666;
  }

  .plant-badges {
    display: flex;
    gap: 0.5rem;
    margin-top: 0.5rem;
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

  .badge.pollinator {
    background: #fef3c7;
    color: #78350f;
  }

  .badge.edible {
    background: #fed7d7;
    color: #742a2a;
  }
</style>
