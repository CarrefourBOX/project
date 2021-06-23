import InputController from "./input_controller";

export default class extends InputController {
	static targets = [ 'tab', 'nextBtn', 'form', 'passwordInput', 'passwordConfirmationInput' ];

	initialize = () => {
		this.showCurrentTab();
	}

	showCurrentTab = () => {
		const currentHash = window.location.hash;
		this.tabTargets.forEach(el => {
			el.classList.remove('current-tab');
		})
		if (currentHash === "") {
			this.tabTargets[0].classList.add('current-tab');
		} else {
			document.querySelector(`.tab${currentHash}`).classList.add('current-tab');
			this.updateBtnSubmit();
		}
		$(this.formTarget).validate();
		this.updateNextBtn();
	}

	nextTab = (e) => {
		let valid = true;
		if (e.currentTarget.type == 'button') { e.preventDefault(); };
		const currentTab = document.querySelector('.tab.current-tab');
		const nextTabIndex = this.tabTargets.indexOf(currentTab) + 1;
		$('[data-validate]:input:visible').each(function() {
			const settings = this.form.ClientSideValidations.settings;
      if (!$(this).isValid(settings.validators)) {
        valid = false
      }
    });
		if (valid) {
			if (nextTabIndex < this.tabTargets.length) {
				history.pushState(null, null, `${window.location.pathname}#${this.tabTargets[nextTabIndex].id}`);
				this.showCurrentTab();
			}
		} else {
			return valid;
		}
	}

	updateBtnSubmit = () => {
		if (this.tabTargets[this.tabTargets.length - 1].classList.contains('current-tab')) {
			this.nextBtnTarget.setAttribute('type', 'submit');
			this.nextBtnTarget.innerText = 'CADASTRAR';
		} else {
			this.nextBtnTarget.setAttribute('type', 'button');
			this.nextBtnTarget.innerText = 'AVANÇAR';
		}
	}

	updateNextBtn = () => {
		const validationInputs = [];
		Array.from($('input:visible')).forEach(input => {
			if (input.value === '' || input.value === undefined || input.classList.contains('is-invalid')) {
				validationInputs.push(false);
			} else {
				validationInputs.push(true)
			}
		})
		if (validationInputs.includes(false)) {
			this.nextBtnTarget.setAttribute('disabled', '');
		} else {
			this.nextBtnTarget.removeAttribute('disabled');
		}
	}

	checkPasswordStrength = (e) => {
    const target = this.passwordInputTarget;
    const hint = target.parentElement.querySelector('small');
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
				this.updateNextBtn()
				return true;
      } else {
        target.classList.remove('medium');
        target.classList.remove('strong');
        target.classList.add('is-invalid');
        hint.innerText = "Fraco";
				return false;
      }
    }
  }

	passwordConfirmationInput = () => {
		const target = this.passwordConfirmationInputTarget;
		if (!this.checkPasswordStrength() || target.value !== this.passwordInputTarget.value) {
			this.nextBtnTarget.setAttribute('disabled', '');
			target.classList.add('is-invalid');
			return false;
		} else {
			this.nextBtnTarget.removeAttribute('disabled');
			target.classList.remove('is-invalid');
			return true;
		}
	}
}
