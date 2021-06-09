import places from "places.js";

async function success(pos, addressInput) {
  const { latitude, longitude } = pos.coords;
  const res = await fetch(
    `https://places-dsn.algolia.net/1/places/reverse?aroundLatLng=${latitude},%20${longitude}&hitsPerPage=1&language=en`
  );
  const data = await res.json();
  const city = data.hits[0].city[0];
  const country = data.hits[0].country;
  addressInput.value = `${city}, ${country}`;
  // addressInput.value = `${addressInput.value} `;
}

function error(err) {
  console.warn(`ERROR(${err.code}): ${err.message}`);
}

const initAutocomplete = () => {
  const addressInput = document.querySelector(".location_con input");
  if (addressInput) {
    const placesAutocomplete = places({
      container: addressInput,
      useDeviceLocation: true,
    });
    // placesAutocomplete.on("locate", (e) => {
    //   console.log("locating");
    //   navigator.geolocation.getCurrentPosition(
    //     (pos) => success(pos, addressInput),
    //     error
    //   );
    // });
  }
};

export { initAutocomplete };
