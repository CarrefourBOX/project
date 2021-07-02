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

  def my_box
    authorize :page
    # @plan = Plan.includes(:orders, :shipments, :address).where(user: current_user).first
    @review = Review.new
    @plan = current_user.plans.includes(:orders, :shipments, :address).order(:created_at).last
    return unless @plan

    @boxes = @plan.box_items.group_by(&:carrefour_box)
    @sizes = @plan.boxes.includes(box_item: :carrefour_box).group_by(&:box_size).each_with_object({}) do |(size, boxes), hash|
      boxes.each do |box|
        hash[box.box_item.carrefour_box.name] = size unless hash[box.box_item.carrefour_box.name]
      end
    end
    # Plan.includes(:orders, :shipments, :address,
    #                        box_items: :carrefour_box).where(user: current_user).each_with_object({}) do |plan, hash|
    #   hash[plan] = plan.box_items.group_by(&:carrefour_box)
    # end
  end

  def my_addresses
    @addresses = current_user.addresses.active.order(main: :desc)
    @address = Address.new(main: @addresses.empty?)
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
