import { Controller } from "stimulus";

export default class extends Controller {
    static targets = ["form"];

    reset() {
        this.formTarget.reset();
    }
}