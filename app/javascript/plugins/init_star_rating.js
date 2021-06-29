import $ from 'jquery'; // <-- if you're NOT using a Le Wagon template (cf jQuery section)
import "jquery-bar-rating";

const initStarRating = () => {
  $('#review_rating').barrating({
    theme: 'css-stars'
  });
};

export { initStarRating };
