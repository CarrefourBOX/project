import { Controller } from "stimulus";
import flatpickr from "flatpickr";
import Inputmask from "inputmask";

export default class extends Controller {
	static targets = [ ];

	initialize = () => {
    if (document.querySelector('.flatpickr')) { this.loadFlatpickr(); }
    if (document.querySelector('[data-mask]')) { this.setInputmask(); }
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
    const hint = e.currentTarget.parentElement.querySelector('small');
    const lengthHint = document.getElementById('length-hint');
    const letterHint = document.getElementById('letter-hint');
    const numberHint = document.getElementById('number-hint');
    if (target.value == "") {
      target.classList.remove('medium');
      target.classList.remove('strong');
      target.classList.remove('is-invalid');
      lengthHint.classList.remove('invalid');
      lengthHint.classList.remove('valid');
      numberHint.classList.remove('invalid');
      numberHint.classList.remove('valid');
      letterHint.classList.remove('invalid');
      letterHint.classList.remove('valid');
      hint.innerText = "";
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
          hint.innerText = "Forte";
        } else {
          target.classList.remove('is-invalid');
          target.classList.remove('strong');
          target.classList.add('medium');
          hint.innerText = "Médio";
        }
      } else {
        target.classList.remove('medium');
        target.classList.remove('strong');
        target.classList.add('is-invalid');
        hint.innerText = "Fraco";
      }
    }
  }

  setInputmask = () => {
    document.querySelectorAll('input[data-mask]').forEach(input => {
      if (input.dataset.mask !== undefined) {
        this.inputmask(input, input.dataset.mask);
      }
    })
  }

  inputmask = (target, type) => {
    switch (type) {
      case 'cpf':
        var im = new Inputmask('999.999.999-99');
        im.mask(target);
        break;
      case 'phone':
        var im = new Inputmask('(99) 9{4,5}-9999');
        im.mask(target);
        break;
    }
  }
}
