class Order < ApplicationRecord
  belongs_to :user
  belongs_to :plan
  monetize :amount_cents
end
