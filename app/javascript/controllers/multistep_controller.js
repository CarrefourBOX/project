import { Controller } from "stimulus";

export default class extends Controller {
	static targets = [ 'tab', 'nextBtn' ];

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
	}

	nextTab = (e) => {
		if (e.currentTarget.type == 'button') { e.preventDefault(); };
		const currentTab = document.querySelector('.tab.current-tab');
		const nextTabIndex = this.tabTargets.indexOf(currentTab) + 1;

		if (nextTabIndex < this.tabTargets.length) {
			history.pushState(null, null, `${window.location.pathname}#${this.tabTargets[nextTabIndex].id}`);
			this.showCurrentTab();
		}
	}

	// formValidation = () => {
	// 	let valid = true;
  //   $('[data-validate]:input:visible').each(function() {
	// 		const settings = window[this.form.id].ClientSideValidations.settings;
  //     if (!$(this).isValid(settings.validators)) {
  //       valid = false
  //     }
  //   });
	// 	return valid;
	// }

	updateBtnSubmit = () => {
		if (this.tabTargets[this.tabTargets.length - 1].classList.contains('current-tab')) {
			this.nextBtnTarget.setAttribute('type', 'submit');
			this.nextBtnTarget.innerText = 'CADASTRAR';
		} else {
			this.nextBtnTarget.setAttribute('type', 'button');
			this.nextBtnTarget.innerText = 'AVANÇAR';
		}
	}
}
