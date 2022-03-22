# frozen_string_literal: true

class Customer < ApplicationRecord
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true
  # POTENTIAL-IMPROVEMENT: could add an email format validator, uniqueness validator, and enforce uniqueness on db column

  has_many :vehicles, dependent: :destroy

  def full_name
    "#{first_name} #{last_name}"
  end
end
