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
