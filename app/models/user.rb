# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  has_many :api_keys, dependent: :destroy

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true

  enum role: %i[user admin]

  after_initialize :set_default_role, if: :new_record?

  accepts_nested_attributes_for :api_keys

  def active_api_keys
    api_keys.active
  end

  private

  def set_default_role
    self.role ||= :user
  end
end
