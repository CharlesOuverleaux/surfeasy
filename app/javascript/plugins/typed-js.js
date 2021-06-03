
import Typed from 'typed.js';

var options = {
  strings: ['<i>First</i> sentence.', '&amp; a second sentence.'],
  typeSpeed: 40
};


const initTyped = (selector) => {
  var typed = new Typed(selector, options);
}

export { initTyped };
