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

const initLandingPage = () => {
  // trigger typed only on homepage
  const levelTyped = document.querySelector(".header p span")
  initTyped(levelTyped)

  let location_element = `
    <div class="location_block">
      <p><strong>Tell us where you are</stong></p>
      <div class="location_con">
        <input type="text" placeholder="Insert location...">
        <img src="assets/location.svg" alt="Loc">
      </div>
    </div>
    `

  let button_element = `
    <a id="homepage_button" href="/spots">
      Search the Ocean
    </a>`

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
    const button = document.querySelector('#homepage_button')

    if (value.length > 0 && !button) {
      // add button
      const location_block = document.querySelector(".location_block")
      location_block.insertAdjacentHTML("beforeend", button_element);

      // Add button eventListener
      const button = document.querySelector('#homepage_button')
      button.addEventListener("click", ev => {
        // get skill & location
        const skill = document.querySelector(".active").innerText
        const location = document.querySelector(".location_con input").value.trim()
        // Change link
        button.href=`/spots/?skill=${skill}&location=${location}`
      })
    }
    else if (value.length == 0 && button) {
      // remove -> avoid searching with empty input
      button.remove()
    }
  }

  const handleSkillClick = (ev) => {
    activateSkill(ev)
    if (location_element !== "") {
      // remove skill pills when location block is added
      $(".form").fadeOut(0)
      // Add location element
      const header = document.querySelector(".header")
      header.insertAdjacentHTML("beforeend", location_element)
      location_element = ""
      // select input field
      const input = document.querySelector(".location_block input")
      // focus and add event listener on the input
      input.focus()
      input.addEventListener("keyup", ev => handleKeyUp(ev))
      }
    }

  // add click listener to every skill
  pills.forEach((pill) => {
    pill.addEventListener("click", ev => handleSkillClick(ev))
  })
}

document.addEventListener('turbolinks:load', () => {
  // Call your functions here, e.g:
  // initSelect2();

  const path = window.location.pathname

  // landing page
  if (path === "/") {
    initLandingPage()
  }

  // show page -> assign share functionality
  // https://developer.mozilla.org/en-US/docs/Web/API/Navigator/share
  const shareIcon = document.querySelector("#share_icon")
  if (shareIcon) {
    shareIcon.addEventListener('click', async () => {
      try {
        await navigator.share({
          url: window.location.href
        })
      } catch(err) {
        console.log("Error sharing: " + err)
      }
    });
  }

});




