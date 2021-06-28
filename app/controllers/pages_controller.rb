class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[home start]

  def home; end

  def start
    @boxes = CarrefourBox.all
  end

  def dashboard
    authorize :page
    @carrefour_box = CarrefourBox.new
    @box_item = BoxItem.new
    @boxes = CarrefourBox.all.includes(:box_items)
  end

  def my_boxes
    authorize :page
    @plans = current_user.plans.includes(:order, :shipments,
                                         box_items: :carrefour_box).each_with_object({}) do |plan, hash|
      hash[plan] = plan.box_items.group_by(&:carrefour_box)
    end
  end

  private

  def sort_box_items
    boxes = CarrefourBox.all.each_with_object(Hash.new({})) do |box, hash|
      hash[box.name] = { 'carrefour_box' => box, 'items' => [] }
    end
    BoxItem.all.each { |item| boxes[item.carrefour_box]['items'] << item }
    boxes
  end
end
