
import Typed from 'typed.js';


const strongStyle = "color: #ffc310; font-family: 'Montserrat', sans-serif; font-weight: 900; letter-spacing: 0.4px";
var options = {
  strings: ['', `Find the best <strong style="${strongStyle}">waves</strong> ^500 around you`, `Search^500, <strong style="${strongStyle}">Surf</strong>^500, Relax^500. Repeat`],
  typeSpeed: 40
};


const initTyped = (selector) => {
  var typed = new Typed(selector, options);
}

export { initTyped };
