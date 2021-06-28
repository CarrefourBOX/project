import { Controller } from "stimulus";

export default class extends Controller {
    format() {
        const rawValue = this.element.value.replaceAll(",", "");
        if (rawValue.length <= 2) {
            this.element.value = rawValue;
        } else {
            const formattedValue =
                rawValue.substring(0, rawValue.length - 2) +
                "," +
                rawValue.substring(rawValue.length - 2, rawValue.length);
            this.element.value = formattedValue;
        }
    }
}