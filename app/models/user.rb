# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  has_many :tokens, dependent: :destroy

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true

  enum role: %i[user admin]

  after_initialize :set_default_role, if: :new_record?

  def generate_call_tokens(count)
    count.times do
      token_created = false
      until token_created
        token = SecureRandom.hex(16)
        token_created = tokens.create(value: token)
      end
    end
  end

  def generate_api_key
    self.api_key = SecureRandom.hex(16)
    save
  end

  def generate_free_call_tokens
    free = ENV.fetch('FREE_TOKENS_REGISTRATION').to_i
    generate_call_tokens(free)
  end

  private

  def set_default_role
    self.role ||= :user
  end
end
