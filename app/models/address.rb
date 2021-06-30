class Address < ApplicationRecord
  belongs_to :user

  geocoded_by :full_address
  after_validation :geocode
  before_validation :generate_full_addresss

  validates :name, :cep, :street, :number, :state, :city, :full_address, presence: true
  validates :main, inclusion: { in: [true, false] }

  private

  def generate_full_addresss
    self.full_address = "#{street}, #{number}, #{city}, #{state}"
  end
end
