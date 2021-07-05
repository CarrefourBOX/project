import { Controller } from "stimulus";
import { post } from "@rails/request.js";
import { Modal } from "bootstrap";
import filterGenerator from "plugins/filter_generator";

export default class extends Controller {
    static targets = [
        "tab",
        "selectedOptions",
        "nextBtn",
        "form",
        "fee",
        "cep",
        "address",
    ];

    connect = () => {
        this.loadRightTab();
        filterGenerator();
        this.updateAddress();
    };

    showCurrentTab = () => {
        const currentHash = window.location.hash;
        this.tabTargets.forEach((el) => {
            el.classList.remove("current-tab");
        });
        if (currentHash === "") {
            this.tabTargets[0].classList.add("current-tab");
            history.pushState(null, null, `${window.location.pathname}#select-box`);
        } else {
            document.querySelector(`.tab${currentHash}`).classList.add("current-tab");
        }
        this.loadSessionBoxInfo();
    };

    loadRightTab = () => {
        const currentHash = window.location.hash;
        const initialTab = document.getElementById("select-box");
        const secondTab = document.getElementById("select-items");

        this.loadSessionBoxInfo();

        if (currentHash !== "" && currentHash !== "#select-box") {
            if (initialTab.querySelectorAll("input:checked").length === 0) {
                history.pushState(null, null, `${window.location.pathname}#select-box`);
            } else if (
                Array.from(secondTab.querySelectorAll("fieldset.selected"))
                .map((fieldset) => {
                    return fieldset.querySelector("input:checked");
                })
                .includes(null)
            ) {
                history.pushState(
                    null,
                    null,
                    `${window.location.pathname}#select-items`
                );
            }
        }
        this.showCurrentTab();
    };

    submitForm = (e) => {
        this.loadSessionBoxInfo();
        Rails.fire(e.currentTarget, "submit");
    };

    showBoxOptions = (input) => {
        const fieldTarget = document.getElementById(`box_${input.value}_items`);
        const boxDivTarget = document.getElementById(`box_${input.value}`);
        if (input.checked) {
            fieldTarget.classList.add("selected");
            fieldTarget
                .querySelectorAll('input[type="checkbox"]')
                .forEach((input) => {
                    input.removeAttribute("disabled");
                });
            boxDivTarget.classList.add("selected");
            boxDivTarget.querySelector("select").removeAttribute("disabled");
        } else {
            fieldTarget.classList.remove("selected");
            fieldTarget
                .querySelectorAll('input[type="checkbox"]')
                .forEach((input) => {
                    input.setAttribute("disabled", "");
                });
            boxDivTarget.classList.remove("selected");
            boxDivTarget.querySelector("select").setAttribute("disabled", "");
        }

        document.getElementById("discount").dataset.boxesSelected =
            document.querySelectorAll("#select-box input:checked").length;
    };

    loadSessionBoxInfo = () => {
        const firstTabCheckboxes = document.querySelectorAll(
            '#select-box input[type="checkbox"]'
        );
        firstTabCheckboxes.forEach((input) => {
            this.showBoxOptions(input);
        });

        const secondTabCheckboxes = document.querySelectorAll(
            '#select-items input[type="checkbox"]:not([disabled])'
        );
        secondTabCheckboxes.forEach((input) => {
            this.showSelectedItems(input);
        });
        this.updateNextBtn();
        this.calculatePlanPrice();
    };
    showSelectedItems = (input) => {
        const itemRow = document.getElementById(`item_${input.value}`);

        if (input.checked) {
            if (itemRow === null) {
                const option = document.createElement("li");
                option.id = `item_${input.value}`;
                option.innerText = input.dataset.item;
                document
                    .getElementById(`box_${input.dataset.box}`)
                    .querySelector("ul")
                    .appendChild(option);
            }
        } else {
            if (itemRow !== null) {
                itemRow.remove();
            }
        }
    };

    calculatePlanPrice = () => {
        // get each selected box price
        const selectedBoxes = document
            .getElementById("select-category")
            .querySelectorAll(".box-options.selected");
        const boxesPrice = Array.from(selectedBoxes).map((box) => {
            return parseInt(box.querySelector("select").value);
        });
        // get delivery fee

        const deliveryFee = this.hasCepTarget ?
            parseInt(this.cepTarget.dataset.fee) :
            0;

        // check if user got a discount
        const discountDiv = document.getElementById("discount");
        const discountObj = JSON.parse(
            discountDiv.dataset.discount.replace(/(\d)=>/g, '"$1": ')
        );
        const maxBoxNumDiscount = Math.max.apply(
            null,
            Object.keys(discountObj).map((v) => {
                return parseInt(v);
            })
        );
        const numSelectedBoxes = parseInt(discountDiv.dataset.boxesSelected);
        let discount = 0;
        if (numSelectedBoxes >= maxBoxNumDiscount) {
            discount = discountObj[`${maxBoxNumDiscount}`];
        } else if (
            Object.keys(discountObj)
            .map((v) => {
                return parseInt(v);
            })
            .includes(numSelectedBoxes)
        ) {
            discount = discountObj[`${numSelectedBoxes}`];
        }
        // calculate the totalValue based on previous values
        const totalValue =
            boxesPrice.reduce((a, b) => a + b, 0) * (1 - discount) + deliveryFee;

        // placing all values in its place
        document.querySelector("#subtotal span").innerText = this.monetize(
            boxesPrice.reduce((a, b) => a + b, 0)
        );
        selectedBoxes.forEach((box) => {
            box.querySelector(".box-price").innerText = this.monetize(
                parseInt(box.querySelector("select").value)
            );
        });
        document.querySelector("#discount span").innerText = this.monetize(
            boxesPrice.reduce((a, b) => a + b, 0) * discount
        );

        document.querySelector("#delivery-fee span").innerText =
            this.monetize(deliveryFee);

        document.querySelector("#total span").innerText = this.monetize(totalValue);
    };

    monetize = (num = 0) => {
        return `R$ ${String(num)
      .replace(/\D/g, "")
      .replace(/^0+$/, "0,00")
      .replace(/^[0\,]*(\d)$/, "0,0$1")
      .replace(/^0*(\d{2})$/, "0,$1")
      .replace(/^0*(\d+)(\d{2})$/, "$1,$2")
      .replace(/(\d)(\d{3})(,\d{2})$/, "$1.$2$3")
      .replace(/(\d)(\d{3})(\.)/, "$1.$2$3")
      .replace(/(\d)(\d{3}\.)/g, "$1.$2")
      .replace(
        /(\d{3})(\d)\.(\d{2})(\d)\.(\d{2})(\d)\.(\d{2})(\d)\,(\d)\d/,
        "$1.$2$3.$4$5.$6$7,$8$9"
      )}`;
    };

    updateNextBtn = () => {
        if (this.isTabValid()) {
            this.nextBtnTarget.removeAttribute("disabled");
        } else {
            this.nextBtnTarget.setAttribute("disabled", "");
        }
    };

    nextTab = (e) => {
        e.preventDefault();
        const currentTab = document.querySelector(".tab.current-tab");
        const nextTabIndex = this.tabTargets.indexOf(currentTab) + 1;
        if (this.isTabValid() && nextTabIndex < this.tabTargets.length) {
            history.pushState(
                null,
                null,
                `${window.location.pathname}#${this.tabTargets[nextTabIndex].id}`
            );
            this.showCurrentTab();
        } else {
            if (!this.validateAddress()) {
                document
                    .getElementById("address-option-button")
                    .insertAdjacentHTML(
                        "beforeend",
                        '<p class="text-danger">adicione um endereço para continuar</p>'
                    );
            }
            if (this.nextBtnTarget.dataset.signedIn === "false") {
                new Modal("#sessionModal").show();
            } else if (this.validateAddress()) {
                this.formTarget.action = "/plans";
                this.formTarget.submit();
            }
        }
    };

    isTabValid = () => {
        const tabFielsets = $("fieldset:visible");
        const fieldsetsChecked = [];
        tabFielsets.each(function() {
            const inputsChecked = [];
            this.querySelectorAll('input[type="checkbox"]').forEach((input) => {
                inputsChecked.push(input.checked);
            });
            fieldsetsChecked.push(inputsChecked.includes(true));
        });
        return !fieldsetsChecked.includes(false);
    };

    deleteBox = (e) => {
        document
            .getElementById(`plan_carrefour_box_${e.currentTarget.dataset.boxTarget}`)
            .click();

        if (
            document.getElementById("select-box").querySelector("input:checked") ===
            null
        ) {
            this.loadRightTab();
        }
    };

    updateAddress() {
        const updateCurrentAddress = () => {
            this.nextBtnTarget.removeAttribute("disabled");
            this.calculatePlanPrice();
        };
        const observer = new MutationObserver(updateCurrentAddress);
        observer.observe(this.addressTarget, { childList: true, subtree: true });
    }

    validateAddress() {
        const address = document.getElementById("current-address-id");
        if (address.value !== "") {
            this.nextBtnTarget.removeAttribute("disabled");
            return true;
        } else {
            return false;
        }
    }
}