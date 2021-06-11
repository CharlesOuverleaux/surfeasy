// import Swiper JS
import Swiper from "swiper";
// import Swiper styles

const initSwiper = () => {
  new Swiper(".swiper-container", {
    speed: 300,
    slidesPerView: 1.22,
    centeredSlides: true,
  });
};

export { initSwiper };
