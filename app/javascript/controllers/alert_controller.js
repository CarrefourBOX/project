import { Controller } from "stimulus";

export default class extends Controller {
	static targets = [ ];

	connect = () => {
    this.autosave_timer = setTimeout(this.closeAlert, 3000)
	}

  closeAlert = () => {
    this.element.classList.remove('show');
    setTimeout(() => { this.element.remove() }, 150);
  }
}
