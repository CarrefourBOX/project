class Review < ApplicationRecord
  belongs_to :user
  belongs_to :carrefour_box

  after_create :update_carrefour_box_rating

  validates :rating, presence: true, inclusion: { in: (1..5).to_a }, numericality: { only_integer: true }

  private

  def update_carrefour_box_rating
    new_rating = carrefour_box.reviews.reduce(0.0) do |total, review|
      review.rating + total
    end.to_f / carrefour_box.reviews.size
    carrefour_box.update(average_rating: new_rating.round(1))
  end
end
