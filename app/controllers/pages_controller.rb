class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[home start]

  def home; end

  def start
    @boxes = BoxName.all
  end

  def dashboard
    authorize :page
    @box_name = BoxName.new
    @box_item = BoxItem.new
    @boxes = sort_box_items
  end

  def my_boxes
    authorize :page
    @plans = []
    current_user.plans.order(created_at: :desc).each do |plan|
      boxes = plan.boxes.each_with_object({}) do |box, hash|
        hash[box.box_item.box_name] = [] unless hash[box.box_item.box_name]
        hash[box.box_item.box_name] << box.box_item.item_name
      end
      @plans << { plan: plan, boxes: boxes }
    end
  end

  private

  def sort_box_items
    boxes = BoxName.all.each_with_object(Hash.new({})) do |box, hash|
      hash[box.name] = { 'box_name' => box, 'items' => [] }
    end
    BoxItem.all.each { |item| boxes[item.box_name]['items'] << item }
    boxes
  end
end
