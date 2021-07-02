class ReviewsController < ApplicationController
  before_action :set_review, only: %i[update destroy]

  def new
    @review = Review.new
  end

  def create
    @carrefour_box = CarrefourBox.find(params[:carrefour_box_id])
    @review = Review.new(review_params)
    authorize @review
    @review.carrefour_box = @carrefour_box
    @review.user = current_user
    flash[:notice] = 'Avaliação adicionada.' if @review.save
    redirect_to my_box_path(anchor: "review-container-#{@review.carrefour_box.id}")
  end

  def update
    authorize @review
    @review.update(review_params)
    @review.valid?
    redirect_to my_box_path
  end

  def destroy
    authorize @review
    flash[:notice] = 'Avaliação excluída.' if @review.destroy
    redirect_to my_box_path(anchor: "review-container-#{@review.carrefour_box.id}")
  end

  private

  def set_review
    @review = Review.find(params[:id])
  end

  def review_params
    params.require(:review).permit(:content, :rating)
  end
end
