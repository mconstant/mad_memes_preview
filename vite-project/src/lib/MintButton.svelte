<!-- App.svelte -->
<script lang="ts">
  import { onMount } from 'svelte';
  import { writable } from 'svelte/store';

  let jsonData = writable<any[]>([]);
  let modalVisible = false;
  let randomItem: any = null;

  async function fetchData() {
    try {
      const response = await fetch('nfts.json');
      if (!response.ok) {
        throw new Error('Network response was not ok');
      }
      jsonData.set(await response.json());
    } catch (error) {
      console.error('Error fetching JSON data:', error);
    }
  }

  onMount(fetchData);

  function chooseRandomItem() {
    const data = $jsonData;
    const randomIndex = Math.floor(Math.random() * data.length);
    randomItem = data[randomIndex];
  }

  function toggleModal() {
    chooseRandomItem();
    modalVisible = !modalVisible;
    if (modalVisible) {
      const mintButton = document.querySelector("#mint");
      mintButton.addEventListener('click', () => {
            document.body.removeChild(modal);
            modalVisible = false;
      });
      const modal = document.createElement('div');
      modal.className = 'modal';

      const content = document.createElement('div');
      content.className = 'modal-content';

      const image = document.createElement('img');
      image.src = randomItem.image;
      image.alt = randomItem.name;
      content.appendChild(image);

      const name = document.createElement('p');
      name.textContent = `Name: ${randomItem.name}`;
      content.appendChild(name);

      const rarity = document.createElement('p');
      rarity.textContent = `Rarity: ${randomItem.rarity}`;
      content.appendChild(rarity);

      const closeButton = document.createElement('button');
      closeButton.textContent = 'Close';
      closeButton.addEventListener('click', () => {
        document.body.removeChild(modal);
        modalVisible = false;
      });

      

      content.appendChild(closeButton);

      modal.appendChild(content);
      document.body.appendChild(modal);
    }
  }
</script>

<style>
  /* Add CSS for the modal */
  .modal {
    display: none;
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    background-color: rgba(0, 0, 0, 0.7);
    z-index: 1000;
    display: flex;
    justify-content: center;
    align-items: center;
  }

  .modal-content {
    background-color: white;
    border-radius: 8px;
    text-align: center;
    padding: 20px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
    max-width: 50vw; 
    overflow: hidden; /* Hide overflow content if it exceeds the limits */
  }

  /* Style the image to fit the modal content */
  img {
    max-width: 50vw;
    max-height: calc(60vh - 225px); /* Allow the image to resize proportionally */
  }
</style>

<button id=mint on:click={toggleModal}>
  "Mint" Random Meme
</button>
