import { Controller } from "stimulus";

export default class extends Controller {
    static targets = ["imgForm", "output", "input"];

    preview() {
        const input = this.inputTarget;
        const output = this.outputTarget;

        if (input.files && input.files[0]) {
            const reader = new FileReader();

            reader.onload = function() {
                output.src = reader.result;
            };

            reader.readAsDataURL(input.files[0]);
        }
    }

    attachImage() {
        this.imgFormTarget.requestSubmit();
    }
}