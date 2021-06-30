class CarrefourBoxesController < ApplicationController
  before_action :set_carrefour_box, only: %i[show update destroy]
  before_action :rating, only: :show

  def show
    skip_authorization
  end

  def create
    @carrefour_box = CarrefourBox.new(carrefour_box_params)
    authorize @carrefour_box
    flash[:notice] = "Caixa '#{@carrefour_box.name}' criada!" if @carrefour_box.save
    redirect_to dashboard_path
  end

  def update
    authorize @carrefour_box
    flash[:notice] = "Caixa '#{@carrefour_box.name}' atualizada!" if @carrefour_box.update(carrefour_box_params)
    redirect_to dashboard_path
  end

  def destroy
    authorize @carrefour_box
    BoxItem.where(carrefour_box: @carrefour_box.name).each(&:destroy)
    flash[:notice] = "Caixa '#{@carrefour_box.name}' removida!"
    @carrefour_box.destroy
    redirect_to dashboard_path
  end

  private

  def carrefour_box_params
    formated = params.require(:carrefour_box).permit(:name, :description, :icon, color: [], plans: {})
    formated[:color] = formated[:color].first if formated[:color].instance_of?(Array)
    formated[:plans] = formated[:plans].transform_values do |value|
      { 'price' => Integer(value.gsub(',', '')) }
    end
    formated
  end

  def set_carrefour_box
    @carrefour_box = CarrefourBox.find(params[:id])
  end

  def rating
    @full_rating = 0
    @carrefour_box.reviews.each do |review|
      @full_rating += review.rating
    end
    @rating = @full_rating.to_f / @carrefour_box.reviews.count
  end
end
