<script lang="ts">
  import { onMount } from 'svelte';

  let plants: any[] = [];
  let search = '';
  let zone = '';
  let habit = '';
  let layer = '';
  let total = 0;
  let loading = false;

  const habits = ['tree', 'shrub', 'herb', 'vine', 'groundcover', 'grass', 'fern'];
  const layers = ['emergent', 'canopy', 'sub-canopy', 'shrub', 'herbaceous', 'ground', 'root', 'vertical'];

  async function searchPlants() {
    loading = true;
    const params = new URLSearchParams();
    if (search) params.set('search', search);
    if (zone) params.set('zone', zone);
    if (habit) params.set('habit', habit);
    if (layer) params.set('layer', layer);

    const response = await fetch(`/api/plants?${params.toString()}`);
    const data = await response.json();
    plants = data.plants;
    total = data.total;
    loading = false;
  }

  onMount(() => {
    searchPlants();
  });

  function handleSearch(e: Event) {
    e.preventDefault();
    searchPlants();
  }
</script>

<svelte:head>
  <title>Syntropy Calculator - Plant Guild Designer</title>
</svelte:head>

<div class="container">
  <header>
    <h1>🌿 Syntropy Calculator</h1>
    <p>Intelligent Planting Guild Designer</p>
    <a href="/guild-builder" class="guild-builder-link">
      🌳 Guild Builder →
    </a>
  </header>

  <section class="search-section">
    <h2>Plant Database ({total.toLocaleString()} plants)</h2>

    <form on:submit={handleSearch}>
      <div class="search-grid">
        <div class="search-field">
          <label for="search">Search by name</label>
          <input
            id="search"
            type="text"
            bind:value={search}
            placeholder="Scientific or common name..."
          />
        </div>

        <div class="search-field">
          <label for="zone">Hardiness Zone</label>
          <select id="zone" bind:value={zone}>
            <option value="">All zones</option>
            {#each Array.from({ length: 13 }, (_, i) => i + 1) as z}
              <option value={z}>Zone {z}</option>
            {/each}
          </select>
        </div>

        <div class="search-field">
          <label for="habit">Growth Habit</label>
          <select id="habit" bind:value={habit}>
            <option value="">All habits</option>
            {#each habits as h}
              <option value={h}>{h}</option>
            {/each}
          </select>
        </div>

        <div class="search-field">
          <label for="layer">Stratification Layer</label>
          <select id="layer" bind:value={layer}>
            <option value="">All layers</option>
            {#each layers as l}
              <option value={l}>{l}</option>
            {/each}
          </select>
        </div>
      </div>

      <button type="submit" disabled={loading}>
        {loading ? 'Searching...' : 'Search'}
      </button>
    </form>
  </section>

  <section class="results">
    {#if loading}
      <p class="loading">Loading plants...</p>
    {:else if plants.length === 0}
      <p class="no-results">No plants found matching your criteria</p>
    {:else}
      <div class="plant-grid">
        {#each plants as plant}
          <div class="plant-card">
            <h3>{plant.scientific_name}</h3>
            <div class="plant-common-names">
              {#each plant.common_names as name}
                <span class="badge">{name}</span>
              {/each}
            </div>
            <div class="plant-details">
              <div class="detail">
                <strong>Family:</strong> {plant.plant_family}
              </div>
              <div class="detail">
                <strong>Habit:</strong> {plant.growth_habit}
              </div>
              <div class="detail">
                <strong>Layer:</strong> {plant.stratification_layer}
              </div>
              <div class="detail">
                <strong>Zones:</strong> {plant.hardiness_zone_min}-{plant.hardiness_zone_max}
              </div>
              {#if plant.nitrogen_fixer}
                <span class="badge nitrogen">N-Fixer</span>
              {/if}
              {#if plant.pollinator_attractant}
                <span class="badge pollinator">🐝 Pollinator</span>
              {/if}
              {#if plant.edible_parts && plant.edible_parts.length > 0}
                <span class="badge edible">🍽️ Edible</span>
              {/if}
            </div>
          </div>
        {/each}
      </div>
    {/if}
  </section>
</div>

<style>
  :global(body) {
    margin: 0;
    padding: 0;
    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    min-height: 100vh;
  }

  .container {
    max-width: 1200px;
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
    opacity: 0.9;
  }

  .guild-builder-link {
    display: inline-block;
    margin-top: 1rem;
    padding: 0.75rem 1.5rem;
    background: rgba(255, 255, 255, 0.2);
    color: white;
    text-decoration: none;
    border-radius: 0.5rem;
    font-weight: 600;
    transition: background 0.3s;
  }

  .guild-builder-link:hover {
    background: rgba(255, 255, 255, 0.3);
  }

  .search-section {
    background: white;
    border-radius: 1rem;
    padding: 2rem;
    box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
    margin-bottom: 2rem;
  }

  .search-section h2 {
    margin-top: 0;
    color: #333;
  }

  .search-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
    gap: 1rem;
    margin-bottom: 1rem;
  }

  .search-field label {
    display: block;
    font-weight: 600;
    margin-bottom: 0.5rem;
    color: #555;
  }

  .search-field input,
  .search-field select {
    width: 100%;
    padding: 0.75rem;
    border: 2px solid #e0e0e0;
    border-radius: 0.5rem;
    font-size: 1rem;
    transition: border-color 0.3s;
  }

  .search-field input:focus,
  .search-field select:focus {
    outline: none;
    border-color: #667eea;
  }

  button {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    color: white;
    border: none;
    padding: 1rem 2rem;
    font-size: 1rem;
    font-weight: 600;
    border-radius: 0.5rem;
    cursor: pointer;
    transition: transform 0.2s;
  }

  button:hover:not(:disabled) {
    transform: translateY(-2px);
  }

  button:disabled {
    opacity: 0.6;
    cursor: not-allowed;
  }

  .results {
    background: white;
    border-radius: 1rem;
    padding: 2rem;
    box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
  }

  .plant-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
    gap: 1.5rem;
  }

  .plant-card {
    border: 2px solid #e0e0e0;
    border-radius: 0.75rem;
    padding: 1.5rem;
    transition: transform 0.2s, box-shadow 0.2s;
  }

  .plant-card:hover {
    transform: translateY(-5px);
    box-shadow: 0 5px 20px rgba(0, 0, 0, 0.1);
    border-color: #667eea;
  }

  .plant-card h3 {
    margin: 0 0 0.5rem 0;
    color: #333;
    font-style: italic;
  }

  .plant-common-names {
    margin-bottom: 1rem;
  }

  .badge {
    display: inline-block;
    background: #e0e7ff;
    color: #4c51bf;
    padding: 0.25rem 0.75rem;
    border-radius: 1rem;
    font-size: 0.875rem;
    margin-right: 0.5rem;
    margin-bottom: 0.5rem;
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

  .plant-details {
    margin-top: 1rem;
  }

  .detail {
    margin-bottom: 0.5rem;
    color: #666;
    font-size: 0.9rem;
  }

  .loading,
  .no-results {
    text-align: center;
    padding: 3rem;
    color: #666;
  }
</style>
