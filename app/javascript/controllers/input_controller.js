import { Controller } from "stimulus";
import flatpickr from "flatpickr";

export default class extends Controller {
	static targets = [ ];

	initialize = () => {
    if (document.querySelector('.flatpickr')) { this.loadFlatpickr(); }
	}

  loadFlatpickr = () => {
    this.fp = flatpickr(".flatpickr", {
      dateFormat: "d/m/Y",
      maxDate: new Date(),
      disableMobile: true
    })
  }

  showHidePassword = (e) => {
    const target = e.currentTarget;
    let ariaAtt = target.getAttribute('aria-selected');
    ariaAtt == "true" ? ariaAtt = "false" : ariaAtt = "true";
    target.setAttribute('aria-selected', ariaAtt);

    const inputPassword = target.parentElement.querySelector('input');
    let inputType = inputPassword.getAttribute('type');
    inputType == "password" ? inputType = "text" : inputType = "password";
    inputPassword.setAttribute('type', inputType);
  }
}
