class Plan < ApplicationRecord

  validates :category, presence: true,
  validates :price, presence: true,
  validates :shipment, presence: true,
  validates :ship_day, presence: true,
  validates :carrefour_card, presence: true,
  validates :user_id, presence: true,
  validates :auto_renew, presence: true,
  validates :quantity, presence: true
end
