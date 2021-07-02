class PlansController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[new shopcart update]
  before_action :skip_authorization, only: %i[new create update shopcart]
  skip_before_action :verify_authenticity_token, only: [:create]

  def new
    @plan = Plan.new
    @carrefour_boxes = CarrefourBox.includes(:box_items).where.not(box_items: { id: nil })
    @boxes = BoxItem.includes(:carrefour_box).group_by(&:carrefour_box)
  end

  def shopcart
    boxesInfo = {}
    if params[:carrefour_box]
      params[:carrefour_box].each do |box|
        boxesInfo[box] = { size_price: params[:box_size][box] }
        if params[:box_items] && params[:box_items].has_key?(box)
          boxesInfo[box]['items'] = params[:box_items][box]
        else
          boxesInfo[box].delete('items')
        end
      end
      session['boxes'] = boxesInfo
    else
      session.delete('boxes')
    end
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(:nav, partial: 'shared/navbar')
      end
    end
  end

  def create
    if session['boxes'].blank?
      flash[:notice] = 'Escolha pelo menos uma BOX'
      redirect_to new_plan_path
      return
    elsif session['boxes'].values.any? { |h| h['items'].nil? }
      flash[:notice] = 'Selecione pelo menos um item para todas BOX selecionadas'
      redirect_to new_plan_path(anchor: 'select-items')
      return
    end

    quantity = session['boxes'].keys.count
    @plan = Plan.new(quantity: quantity)
    @plan.user = current_user
    @plan.address = current_user.addresses.where(main: true).first
    return unless @plan.quantity && @plan.save

    current_user.plans.where.not(id: @plan.id).destroy_all

    session['boxes'].each do |k, v|
      create_plan_boxes(@plan, k, v)
    end

    @plan.calculate_total
    flash[:notice] = 'Plano criado!'
    redirect_to @plan
  end

  def show
    @plan = Plan.includes(box_items: :carrefour_box).find(params[:id])
    authorize @plan
  end

  def update
    @plan = Plan.find(params[:id])
    @plan.update(plan_params)
  end

  def destroy
    @plan = Plan.find(params[:id])
    authorize @plan
    flash[:notice] = 'Plano cancelado!' if @plan.destroy
    redirect_to cancel_path
  end

  def update_my_box
    plan = Plan.find(params[:id])
    authorize plan
    carrefour_box = CarrefourBox.find(params[:carrefour_box])
    boxes = plan.boxes.includes(box_item: :carrefour_box).where(box_size: params[:box_size]).where(box_items: { carrefour_box: carrefour_box })

    destroy_plan_boxes(plan, carrefour_box) if boxes.empty?
    update_box_items(plan, params[:box_size], boxes, params[:items])
    plan.calculate_total
    redirect_to my_box_path
  end

  def cancel_box
    plan = Plan.find(params[:id])
    carrefour_box = CarrefourBox.find(params[:carrefour_box])
    authorize plan
    destroy_plan_boxes(plan, carrefour_box)
    if plan.boxes.empty?
      plan.destroy
    else
      update_quantity(plan)
      plan.calculate_total
    end
    redirect_to my_box_path
  end

  private

  def create_plan_boxes(plan, box, box_params)
    box_size = CarrefourBox.find(box.to_i).plans.select do |_k, v|
      v['price'] == box_params['size_price'].to_i
    end.keys.first
    box_params['items'].each do |item|
      Box.create(plan: plan, box_item: BoxItem.find(item.to_i), box_size: box_size)
    end
  end

  def update_box_items(plan, box_size, boxes, items)
    boxes.destroy_all

    items.each do |item|
      Box.create(plan: plan, box_size: box_size, box_item: BoxItem.find(item))
    end
  end

  def destroy_plan_boxes(plan, box)
    plan.boxes.includes(box_item: :carrefour_box).where(box_item: { carrefour_box: box }).destroy_all
  end

  def plan_params
    params.require(:plan).permit(:carrefour_card)
  end

  def update_quantity(plan)
    quantity = plan.boxes.includes(box_item: [carrefour_box: :reviews]).group_by do |box|
      box.box_item.carrefour_box
    end.size
    plan.update(quantity: quantity)
  end
end
