
import Typed from 'typed.js';

var options = {
  strings: ['', 'Find the best <strong style="color:#0050ff">waves</strong> ^500 around you', 'Search^500, <strong>Surf</strong>^500, Relax ^500. Repeat'],
  typeSpeed: 40
};


const initTyped = (selector) => {
  var typed = new Typed(selector, options);
}

export { initTyped };
