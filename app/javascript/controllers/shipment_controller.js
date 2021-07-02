import { Controller } from "stimulus";
import { post } from "@rails/request.js";

export default class extends Controller {
    static targets = ["cep", "fee"];

    async fetchAddress() {
        if (this.cepTarget.value.length >= 8) {
            console.log(this.cepTarget.value);
            const response = await post("/calculate_shipment", {
                responseKind: "json",
                body: { cep: this.cepTarget.value },
            });
            if (response.ok) {
                const data = await response.json;
                console.log(data.shipment);
                this.feeTarget.dataset.price = data.shipment;
            }
        }
    }
}