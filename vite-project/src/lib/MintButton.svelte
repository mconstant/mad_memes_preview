<script lang="ts">
  import NFTPreview from './NFTPreview.svelte'

  const getRandomNftPreview = () => {
    alert(`Minted NFT: foo`);
  }
</script>

<button on:click={getRandomNftPreview}>
  Get Random NFT
</button>
