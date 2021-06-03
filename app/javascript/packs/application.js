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
import { initTyped } from 'plugins/typed-js.js'

// Internal imports, e.g:
// import { initSelect2 } from '../components/init_select2';

document.addEventListener('turbolinks:load', () => {
  // Call your functions here, e.g:
  // initSelect2();

  let location_element = `
    <p><strong>Tell us where you are</stong></p>
    <div class="location_con">
      <input type="text" placeholder="Insert location...">
      <img src="assets/location.svg" alt="Loc">
    </div>`

  let button_element = `
    <a href="/spots">
      Search the Ocean
    </a>`
  let buttonAdded = false

  // get important elements
  const pills = document.querySelectorAll(".skill_pill")
  const form = document.querySelector("#banner .form")

  const activateSkill = (ev) => {
    // remove active for all
    pills.forEach((pill) => {
      pill.classList.remove("active")
    })
    // add active to selected
    ev.currentTarget.classList.add("active")
  }

  const handleKeyUp = (ev) => {
    const value = ev.currentTarget.value.trim()

    if (value.length > 0 && !buttonAdded) {
      // add button
      form.insertAdjacentHTML("beforeend", button_element);
      buttonAdded = true

      // Add button eventListener
      const button = form.lastChild
      button.addEventListener("click", ev => {
        // get skill & location
        const skill = form.querySelector(".active").innerText
        const location = form.querySelector("input").value.trim()
        // Change link
        button.href=`/spots/?skill=${skill}&location=${location}`
      })
    }
    else if (value.length == 0 && buttonAdded) {
      // remove -> avoid searching with empty input
      form.removeChild(form.lastChild);
      buttonAdded = false
    }
  }

  const handleSkillClick = (ev) => {
    activateSkill(ev)
    if (location_element !== "") {
      form.insertAdjacentHTML("beforeend", location_element);
      location_element = ""
      // add input listener
      const input = form.querySelector("input")
      input.addEventListener("keyup", ev => handleKeyUp(ev))
    }
  }

  // add click listener to every skill
  pills.forEach((pill) => {
    pill.addEventListener("click", ev => handleSkillClick(ev))
  })

});




