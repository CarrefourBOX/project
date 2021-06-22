import { Controller } from "stimulus";
import flatpickr from "flatpickr";

export default class extends Controller {
	static targets = [ ];

	initialize = () => {
    if (document.querySelector('.flatpickr')) {
      this.loadFlatpickr();
    }
	}

  loadFlatpickr = () => {
    this.fp = flatpickr(".flatpickr", {
      dateFormat: "d/m/Y",
      maxDate: new Date(),
      disableMobile: true
    })
  }
}
