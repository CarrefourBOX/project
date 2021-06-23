class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # validations
  validates :first_name, :last_name, :birth_date, :cpf, :phone, presence: true, unless: :admin?
  validates :password, format: { with: /(.*([A-Za-z]+[0-9]|[0-9]+[A-Za-z]).*)/ }

  # private

  # def password_format
  #   return if password.blank? || !password.match?(/([A-Za-z]+[0-9]|[0-9]+[A-Za-z])/)

  #   errors.add(:password, 'com formato inválido')
  # end
end
