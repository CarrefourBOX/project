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

  checkPasswordStrength = (e) => {
    const target = e.currentTarget;
    const lengthHint = document.getElementById('length-hint');
    const letterHint = document.getElementById('letter-hint');
    const numberHint = document.getElementById('number-hint');
    if (target.value == "") {
      lengthHint.classList.remove('invalid');
      lengthHint.classList.remove('valid');
      numberHint.classList.remove('invalid');
      numberHint.classList.remove('valid');
      letterHint.classList.remove('invalid');
      letterHint.classList.remove('valid');
    } else {
      if (target.value.length >= 6) {
        lengthHint.classList.remove('invalid');
        lengthHint.classList.add('valid');
      } else {
        lengthHint.classList.remove('valid');
        lengthHint.classList.add('invalid');
      }
      if (target.value.match(/\d+/)) {
        numberHint.classList.remove('invalid');
        numberHint.classList.add('valid');
      } else {
        numberHint.classList.remove('valid');
        numberHint.classList.add('invalid');
      }
      if (target.value.match(/[a-zA-Z]+/)) {
        letterHint.classList.remove('invalid');
        letterHint.classList.add('valid');
      } else {
        letterHint.classList.remove('valid');
        letterHint.classList.add('invalid');
      }
      if (target.value.length >= 6 && target.value.match(/\d+/) && target.value.match(/[a-z]+/)) {
        if (target.value.match(/[A-Z]+/) && target.value.match(/[-!$%^&*()_+|~=`{}\[\]:";'<>?,.\/]+/)) {
          target.classList.remove('is-invalid');
          target.classList.remove('medium');
          target.classList.add('strong');
        } else {
          target.classList.remove('is-invalid');
          target.classList.remove('strong');
          target.classList.add('medium');
        }
      } else {
        target.classList.remove('medium');
        target.classList.remove('strong');
        target.classList.add('is-invalid');
      }
    }
  }
}
