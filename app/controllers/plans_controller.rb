class PlansController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[new]

  def new
    skip_authorization
    @items = sort_box_items
  end

  def create
    skip_authorization
    @plan = Plan.new(quantity: params[:boxes].keys.size, category: params[:category])
    @plan.user = current_user
    @plan.ship_day = set_ship_day
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

  def show
    skip_authorization
    @plan = Plan.find(params[:id])
    @plan.payment = true
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

  def set_ship_day
    day = Date.today.day
    if day >= 9 && day <= 18
      '20'
    elsif day >= 19 && day <= 28
      '30'
    else
      '10'
    end
  end
end
