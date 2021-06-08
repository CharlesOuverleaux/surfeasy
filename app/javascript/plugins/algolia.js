import places from 'places.js';

const initAutocomplete = () => {
  const addressInput = document.querySelector(".location_con input")
  console.log(addressInput);
  if (addressInput) {
    places({ container: addressInput });
  }
};

export { initAutocomplete };