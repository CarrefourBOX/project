import MultistepController from "./multistep_controller";

export default class extends MultistepController {
	static targets = ['tab'];

	connect = () => {
    // this.showCurrentTab();
	}

  showBoxOptions = () => {
    console.log('pudim')
  }

  updateBtnSubmit = () => {
    if (this.tabTargets[this.tabTargets.length - 1].classList.contains('current-tab')) {
			this.nextBtnTarget.setAttribute('type', 'submit');
			this.nextBtnTarget.innerText = 'Ir ao carrinho';
		} else {
			this.nextBtnTarget.setAttribute('type', 'button');
			this.nextBtnTarget.innerText = 'Continuar';
		}
  }

  updateNextBtn = () => {
    const validationFieldsets = [];
    const currentTab = document.querySelector('.tab.current-tab');

    currentTab.querySelectorAll('fieldset').forEach(fieldset => {
      const validationInputs = [];
      fieldset.querySelectorAll('input').forEach(input => {
        if (input.checked) { validationInputs.push(true) }
      })
      if (validationInputs.includes(true)) { validationFieldsets.push(true) }
    })

		if (validationFieldsets.includes(true)) {
      this.nextBtnTarget.removeAttribute('disabled');
		} else {
			this.nextBtnTarget.setAttribute('disabled', '');
		}
  }

  nextTab = () => {
    let valid = true;
		if (e.currentTarget.type == 'button') { e.preventDefault(); };
		const currentTab = document.querySelector('.tab.current-tab');
		const nextTabIndex = this.tabTargets.indexOf(currentTab) + 1;
  }
}
