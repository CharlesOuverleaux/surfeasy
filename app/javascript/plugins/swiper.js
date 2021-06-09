// import Swiper JS
import Swiper from "swiper";
// import Swiper styles

const initSwiper = () => {
  new Swiper(".swiper-container", {
    speed: 400,
    slidesPerView: 1.2,
    centeredSlides: true,
    spaceBetween: 10,
  });
};

export { initSwiper };
