# frozen_string_literal: true

class Vehicle < ApplicationRecord
  validates :category, presence: true
  validates :name, presence: true
  validates :length, presence: true

  belongs_to :customer
end
