class ReviewsController < ApplicationController
  def new
    @review = Review.new
  end

  def create
    skip_authorization
    @carrefour_box = CarrefourBox.find(params[:carrefour_box_id])
    @review = Review.new(review_params)
    @review.carrefour_box = @carrefour_box
    @review.user = current_user
    if @review.save
      respond_to do |format|
        format.html { redirect_to my_boxes_path(anchor: "comment-container") }
        format.js # <-- will render `app/views/reviews/create.js.erb`
      end
    else
      respond_to do |format|
        format.html { render 'my_boxes/show' }
        format.js # <-- idem
      end
    end
  end

  private

  def review_params
    params.require(:review).permit(:content, :rating)
  end
end
