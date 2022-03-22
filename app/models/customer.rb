# frozen_string_literal: true

class Customer < ApplicationRecord
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true
  # POTENTIAL-IMPROVEMENT: could add an email format validator, uniqueness validator, and enforce uniqueness on db column

  has_many :vehicles, dependent: :destroy

  scope :by_full_name, -> { all.to_a.sort_by(&:full_name) }
  scope :by_vehicle_type, ->(direction = 'asc') { includes(:vehicles).where('vehicles.primary = true').order("vehicles.category #{direction}") }
  scope :all_data, -> { includes(:vehicles).map { |customer| customer.serializable_hash.merge(vehicles: customer.vehicles.map(&:serializable_hash)) } }

  def full_name
    "#{first_name} #{last_name}"
  end
end
