class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # validations
  validates :first_name, :last_name, :birth_date, :cpf, :phone, presence: true, if: -> (user) { !user.admin }
  validates :password, format: { with: /([A-Za-z]+[0-9]|[0-9]+[A-Za-z]).+/ }
end
