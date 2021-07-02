import { Controller } from "stimulus";
import $ from "jquery";
import "jquery-bar-rating";

export default class extends Controller {
    connect() {
        $(this.element).barrating({
            theme: "css-stars",
        });
    }
}