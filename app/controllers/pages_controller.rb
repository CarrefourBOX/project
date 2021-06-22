class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[home]
  def home; end

  def dashboard
    authorize :page
    @box_name = BoxName.new
    @box_item = BoxItem.new
    @boxes = sort_box_items
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
