import MultistepController from "./multistep_controller";

export default class extends MultistepController {
	static targets = ['tab', 'selectedOptions'];

	connect = () => {
    this.loadRightTab();
    this.updateNextBtn();
    this.setEvents();
	}

  setEvents = () => {
    const selectBoxTab = document.getElementById('select-box');
    const selectBoxItemsTab = document.getElementById('select-items');
    const selectBoxSizes = document.getElementById('select-category');

    selectBoxTab.querySelectorAll('input').forEach(input => {
      input.setAttribute('data-action', 'change->new-plan#updateBoxOptions');
    })
    selectBoxItemsTab.querySelectorAll('input').forEach(input => {
      input.setAttribute('data-action', 'change->new-plan#updateSelectedItems');
    })
    selectBoxSizes.querySelectorAll('select').forEach(input => {
      input.setAttribute('data-action', 'change->new-plan#calculatePlanPrice');
    })
  }

  loadRightTab = () => {
    const currentTab = document.querySelector('.tab.current-tab');
    const currentTabIndex = this.tabTargets.indexOf(currentTab);
    const initialTab = document.getElementById('select-box');
    if (currentTab !== initialTab) {
      if (initialTab.querySelectorAll('input:checked').length === 0) {
        history.pushState(null, null, `${window.location.pathname}#${this.tabTargets[0].id}`);
      } else {
  
      }
    }
    if (currentTabIndex !== 0 && this.tabTargets[this.tabTargets.indexOf(currentTab)])
    if (currentTab.querySelectorAll('input[type="checkbox"]').length === 0) {
    }
    this.showCurrentTab();
  }

  submitForm = (target) => {
    Rails.fire(target, 'submit');
  }

  updateBoxOptions = (e) => {
    const input = e.currentTarget;

    const fieldTarget = document.getElementById(`box_${input.value}_items`);
    const boxDivTarget = document.getElementById(`box_${input.value}`);
    if (input.checked) {
      fieldTarget.classList.add('selected');
      boxDivTarget.classList.add('selected');
    } else {
      fieldTarget.classList.remove('selected');
      boxDivTarget.classList.remove('selected');
    }

    document.getElementById('discount').dataset.boxesSelected = document.querySelectorAll('#select-box input:checked').length;
    this.updateNextBtn();
    this.calculatePlanPrice();
    this.submitForm(input.form);
  }

  updateSelectedItems = (e) => {
    const input = e.currentTarget;
    const itemRow = document.getElementById(`item_${input.value}`);

    if (input.checked) {
      if (itemRow === null) {
        const option = document.createElement('li');
        option.id = `item_${input.value}`;
        option.innerText = input.dataset.item;
        document.getElementById(`box_${input.dataset.box}`).querySelector('ul').appendChild(option);
      }
    } else {
      if (itemRow !== null) {
        itemRow.remove();
      }
    }
    this.updateNextBtn();
  }

  updateBoxValues = () => {
    console.log('pudim')
  }

  calculatePlanPrice = () => {
    // get each selected box price
    const selectedBoxes = document.getElementById('select-category').querySelectorAll('.box-options.selected');
    const boxesPrice = Array.from(selectedBoxes).map(box => {
      return parseInt(box.querySelector('select').value);
    })
    // get delivery fee
    const deliveryFee = document.getElementById('delivery-fee').dataset.price ? parseInt(document.getElementById('delivery-fee').dataset.price) : 0;
    // check if user got a discount
    const discountDiv = document.getElementById('discount');
    const discountObj = JSON.parse(discountDiv.dataset.discount.replace(/(\d)=>/g, '"$1": '));
    const maxBoxNumDiscount = Math.max.apply(null, Object.keys(discountObj).map(v => { parseInt(v) }));
    const numSelectedBoxes = parseInt(discountDiv.dataset.boxesSelected);
    let discount = 0;
    if (numSelectedBoxes >= maxBoxNumDiscount) {
      discount = discountObj[`${maxBoxNumDiscount}`];
    } else if (Object.keys(discountObj).map(v => { parseInt(v) }).includes(numSelectedBoxes)) {
      discount = discountObj[`${numSelectedBoxes}`];
    }
    // calculate the totalValue based on previous values
    const totalValue = (boxesPrice.reduce((a, b) => a + b, 0) * (1 + discount)) + deliveryFee;

    // placing all values in its place
    document.querySelector("#subtotal span").innerText = this.monetize(boxesPrice.reduce((a, b) => a + b, 0));
    document.querySelector("#discount span").innerText = `${discount}%`;
    if (document.getElementById('delivery-fee').dataset.price) {
      document.querySelector("#delivery-fee span").innerText = this.monetize(deliveryFee);
    }
    document.querySelector("#total span").innerText = this.monetize(totalValue);
  }

  monetize = (num = 0) => {
    return `R$ ${String(num).replace(/\D/g, "")
                            .replace(/^0+$/, "0,00")
                            .replace(/^[0\,]*(\d)$/, "0,0$1")
                            .replace(/^0*(\d{2})$/, "0,$1")
                            .replace(/^0*(\d+)(\d{2})$/, "$1,$2")
                            .replace(/(\d)(\d{3})(,\d{2})$/, "$1.$2$3")
                            .replace(/(\d)(\d{3})(\.)/, "$1.$2$3")
                            .replace(/(\d)(\d{3}\.)/g, "$1.$2")
                            .replace(/(\d{3})(\d)\.(\d{2})(\d)\.(\d{2})(\d)\.(\d{2})(\d)\,(\d)\d/, "$1.$2$3.$4$5.$6$7,$8$9")}`
  }

  updateBtnSubmit = () => {
    if (this.tabTargets[this.tabTargets.length - 1].classList.contains('current-tab')) {
			this.nextBtnTarget.setAttribute('type', 'submit');
		} else {
			this.nextBtnTarget.setAttribute('type', 'button');
		}
  }

  updateNextBtn = () => {
		if (this.isTabValid()) {
      this.nextBtnTarget.removeAttribute('disabled');
		} else {
			this.nextBtnTarget.setAttribute('disabled', '');
		}
  }

  nextTab = (e) => {
		if (e.currentTarget.type == 'button') { e.preventDefault(); };
    const currentTab = document.querySelector('.tab.current-tab');
		const nextTabIndex = this.tabTargets.indexOf(currentTab) + 1;
    if (this.isTabValid() && nextTabIndex < this.tabTargets.length) {
      history.pushState(null, null, `${window.location.pathname}#${this.tabTargets[nextTabIndex].id}`);
      this.showCurrentTab();
    }
  }

  isTabValid = () => {
    const currentTab = document.querySelector('.tab.current-tab');
    const tabFielsets = $('fieldset:visible');
    const fieldsetsChecked = [];
    tabFielsets.each(function() {
      const inputsChecked = [];
      this.querySelectorAll('input[type="checkbox"]').forEach(input => {
        inputsChecked.push(input.checked);
      })
      fieldsetsChecked.push(inputsChecked.includes(true));
    })
    return !fieldsetsChecked.includes(false);
  }
}
