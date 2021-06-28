class Order < ApplicationRecord
  belongs_to :user
  belongs_to :plan
  monetize :amount_cents

  validates :status, inclusion: { in: %w[pending complete canceled] }
end
