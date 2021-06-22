class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # validations
  validates :first_name, :last_name, :birth_date, :cpf, :phone, presence: true, if: -> (user) { !user.admin }
end
