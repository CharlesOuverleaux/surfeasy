// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

Rails.start()
Turbolinks.start()
ActiveStorage.start()


// ----------------------------------------------------
// Note(lewagon): ABOVE IS RAILS DEFAULT CONFIGURATION
// WRITE YOUR OWN JS STARTING FROM HERE 👇
// ----------------------------------------------------

// External imports
import "bootstrap";

// Internal imports, e.g:
// import { initSelect2 } from '../components/init_select2';

document.addEventListener('turbolinks:load', () => {
  // Call your functions here, e.g:
  // initSelect2();

  let location_element = `
    <div class="location_con">
      <input type="text" placeholder="Insert location...">
      <img src="assets/location.png" alt="Loc">
    </div>`

  // get all skill pills
  const pills = document.querySelectorAll(".skill_pill")

  const insertLocation = () => {
    const form = document.querySelector("#banner .form")
    console.log(form)
    form.insertAdjacentHTML("beforeend", location_element);
    location_element = ""
  }

  const activateSkill = (ev) => {
    // remove active state
    pills.forEach((pill) => {
      pill.classList.remove("active")
    })
    // add active to selected
    ev.currentTarget.classList.add("active")
  }

  const handleSkillClick = (ev) => {
    activateSkill(ev)
    if (location_element !== "") {
      insertLocation()
    }
  }

  // add click listener to every skill
  pills.forEach((pill) => {
    pill.addEventListener("click", ev => handleSkillClick(ev))
  })

});
