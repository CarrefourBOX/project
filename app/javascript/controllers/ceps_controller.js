import { Controller } from "stimulus";
import { post } from "@rails/request.js";

export default class extends Controller {
    static targets = ["cep", "street", "city", "state"];
    async fetchAddress() {
        if (this.cepTarget.value.length >= 8) {
            const response = await post("/fetch_address", {
                responseKind: "json",
                body: { cep: this.cepTarget.value },
            });
            if (response.ok) {
                const address = await response.json;
                this.streetTarget.value = address.street;
                this.cityTarget.value = address.city;
                this.stateTarget.value = address.state;
            }
        }
    }
}