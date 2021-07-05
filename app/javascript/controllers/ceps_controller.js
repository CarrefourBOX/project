import { Controller } from "stimulus";
import { post } from "@rails/request.js";

export default class extends Controller {
    static targets = ["cep", "street", "city", "state", "form", "feedback"];

    reset() {
        this.formTarget.reset();
    }

    async fetchAddress() {
        if (this.cepTarget.value.length >= 8) {
            const response = await post("/fetch_address", {
                responseKind: "json",
                body: { cep: this.cepTarget.value },
            });
            if (response.ok) {
                const data = await response.json;
                if (data.address === "formato inválido") {
                    this.streetTarget.value = "";
                    this.cityTarget.value = "";
                    this.stateTarget.value = "";
                    this.feedbackTarget.innerHTML =
                        "<p class='text-danger text-center'>formato inválido</p>";
                } else if (data.address === "CEP não encontrado") {
                    this.streetTarget.value = "";
                    this.cityTarget.value = "";
                    this.stateTarget.value = "";
                    this.feedbackTarget.innerHTML =
                        "<p class='text-danger text-center'>CEP não encontrado</p>";
                } else {
                    this.feedbackTarget.innerHTML = "";
                    this.streetTarget.value = data.address.street;
                    this.cityTarget.value = data.address.city;
                    this.stateTarget.value = data.address.state;
                }
            }
        }
    }
}