class PlansController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[new shopcart]
  before_action :skip_authorization, only: %i[new create show destroy shopcart]

  def new
    @plan = Plan.new
    @carrefour_boxes = CarrefourBox.includes(:box_items).where.not(box_items: { id: nil })
    @boxes = BoxItem.includes(:carrefour_box).group_by(&:carrefour_box)
    # @items = BoxItem.where(id: )
    respond_to do |format|
      format.json do
        render json: { content: render_to_string(partial: 'plans/select_items', formats: :html, layout: false) }
      end
      format.html
    end
  end

  def shopcart
    # session[:box_items_cart] = params[:box_items]
    puts 'bacon'
  end

  def show
    @plan = Plan.includes(box_items: :carrefour_box).find(params[:id])
    authorize @plan
  end

  def create
    @plan = Plan.new(quantity: params[:boxes]&.keys&.size, category: params[:category])
    @plan.user = current_user
    if @plan.quantity && @plan.save
      create_plan_boxes(@plan, params[:boxes])
      @plan.calculate_total
      flash[:notice] = 'Plano criado!'
      redirect_to plan_path(@plan)
    else
      @boxes = BoxItem.includes(:carrefour_box).group_by(&:carrefour_box)
      flash[:notice] = 'Escolha pelo menos uma BOX'
      render :new
    end
  end

  def destroy
    authorize @plan
    @plan = Plan.find(params[:id])
    flash[:notice] = 'Plano cancelado!' if @plan.destroy
    redirect_to cancel_path
  end

  def toggle_auto_renew
    @plan = Plan.find(params[:id])
    authorize @plan
    if @plan.auto_renew
      @plan.update(auto_renew: false)
      flash[:notice] = 'Renovação automática cancelada'
    else
      @plan.update(auto_renew: true)
      flash[:notice] = 'Renovação automática ativada'
    end
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(@plan,
                                                  partial: 'plans/plan',

                                                  locals: { plan: @plan })
      end
    end
  end

  private

  def create_plan_boxes(plan, boxes)
    boxes.each do |_k, v|
      v.each { |item| Box.create(plan: plan, box_item: BoxItem.find(item.to_i)) }
    end
  end
end
