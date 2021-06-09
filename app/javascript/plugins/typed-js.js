
import Typed from 'typed.js';

var options = {
  strings: ['', 'Find the best <strong style="color:orange">waves</strong> ^500 around you', 'Search^500, <strong style="color:orange">Surf</strong>^500, Relax ^500. Repeat'],
  typeSpeed: 40
};


const initTyped = (selector) => {
  var typed = new Typed(selector, options);
}

export { initTyped };
