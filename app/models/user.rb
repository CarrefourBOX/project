class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :plans, dependent: :destroy
  has_many :boxes, through: :plans
  has_many :box_items, through: :boxes
  has_many :orders

  # validations
  validates :first_name, :last_name, :birth_date, :cpf, :phone, presence: true, unless: :admin?
  validates :password, format: { with: /(.*([A-Za-z]+[0-9]|[0-9]+[A-Za-z]).*)/ }
  validates :cpf, uniqueness: true, format: { with: /\A(\d{11}|\d{3}\.\d{3}\.\d{3}-\d{2})\z/ }

  attr_writer :login

  def login
    @login || cpf || email
  end

  def name
    "#{first_name.split.map(&:capitalize) * ' '} #{last_name.split.map(&:capitalize) * ' '}"
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_h).where(['lower(cpf) = :value OR lower(email) = :value', { value: login.downcase }]).first
    elsif conditions.key?(:cpf) || conditions.key?(:email)
      where(conditions.to_h).first
    end
  end
end
