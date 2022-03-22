# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Customer, type: :model do
  describe 'attributes' do
    it { is_expected.to respond_to(:first_name)}
    it { is_expected.to respond_to(:last_name)}
    it { is_expected.to respond_to(:email)}
  end

  describe 'associations' do
    it { is_expected.to have_many(:vehicles) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_presence_of(:last_name) }
    it { is_expected.to validate_presence_of(:email) }
  end
end
