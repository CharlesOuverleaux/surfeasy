// import Swiper JS
import Swiper from "swiper";
// import Swiper styles
import "swiper/swiper-bundle.css";
const initSwiper = () => {
  new Swiper(".swiper-container", {
    speed: 400,
    slidesPerView: 1.15,
    centeredSlides: true,
    spaceBetween: 10,
  });
};

export { initSwiper };
