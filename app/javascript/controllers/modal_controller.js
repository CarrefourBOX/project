import { Controller } from "stimulus";

export default class extends Controller {
	static targets = [ ];

	connect = () => {
	}

  emptyModal = (e) => {
    const [response] = e.detail;
    Swal.fire({
      title: '',
      html: `<div id="modal-content"></div>`,
      showConfirmButton: false,
      focusConfirm: false,
      width: '95%',
      showClass: { popup: '' },
    })
    document.getElementById('modal-content').innerHTML = response.content;
  }
}
