import { Controller } from "stimulus";
import slick from 'slick-carousel';

export default class extends Controller {
	static targets = [ ];

	connect = () => {
    this.initSlick();
	}

  initSlick = () => {
    $('.carousel').slick({
      dots: true,
      autoplay: true,
      arrows: false,
    })
  }
}
