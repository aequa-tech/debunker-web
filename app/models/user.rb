# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  has_many :api_keys, dependent: :destroy
  belongs_to :role

  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :first_name, :last_name, presence: true
  validate :password_complexity, if: -> { password.present? }

  after_initialize :set_default_role, if: :new_record?
  after_commit :create_api_key, on: :create

  accepts_nested_attributes_for :api_keys

  def info_attributes
    attributes.slice('first_name', 'last_name', 'email').merge('role' => role.name)
  end

  def active_api_keys
    api_keys.active
  end

  def admin?
    role.role_type.to_sym == :admin
  end

  private

  def password_complexity
    return if password.blank? || password =~ /(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-])/

    errors.add :password, :too_weak
  end

  def set_default_role
    self.role ||= Role.find_by(name: 'Basic', role_type: :user)
  end

  def create_api_key
    return if api_keys.any?

    api_keys.create(ApiKey.generate_key_pair)
  end
end
