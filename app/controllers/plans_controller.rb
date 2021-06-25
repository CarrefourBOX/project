class PlansController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[new]

  def new
    skip_authorization
    @items = sort_box_items
  end

  def show
    @plan = Plan.find(params[:id])
    authorize @plan
    @boxes = sort_boxes(@plan)
  end

  def create
    skip_authorization
    @plan = Plan.new(quantity: params[:boxes].keys.size, category: params[:category])
    @plan.user = current_user
    if @plan.save
      create_boxes(@plan, params[:boxes])
      flash[:notice] = 'Plan created!'
      redirect_to plan_path(@plan)
    else
      @items = sort_box_items
      flash[:notice] = @plan.errors.full_messages.join(', ')
      render :new
    end
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

  def create_boxes(plan, boxes)
    boxes.each do |_k, v|
      v.each { |item| Box.create(plan: plan, box_item: BoxItem.find(item.to_i)) }
    end
  end

  def sort_box_items
    BoxItem.all.each_with_object({}) do |item, hash|
      hash[item.box_name] = [] unless hash[item.box_name]
      hash[item.box_name] << item
    end
  end

  def sort_boxes(plan)
    plan.boxes.each_with_object({}) do |box, hash|
      hash[box.box_item.box_name] = [] unless hash[box.box_item.box_name]
      hash[box.box_item.box_name] << box.box_item.item_name
    end
  end
end
