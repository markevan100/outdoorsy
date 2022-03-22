# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ClientDataParser, type: :model do
  describe 'process files' do
    context 'when file is a csv' do
      it 'creates Customer and Vehicle objects' do
        described_class.parse('spec/file_fixtures/commas.txt')

        expect(Vehicle.count).to eq Customer.count
      end

      it 'creates using multiple files' do
        described_class.parse('spec/file_fixtures/commas.txt')
        described_class.parse('spec/file_fixtures/commas_2.txt')

        expect(Vehicle.count).to eq 6
      end

      it 'does not create duplicate customers' do
        described_class.parse('spec/file_fixtures/commas.txt')
        described_class.parse('spec/file_fixtures/commas_2.txt')

        expect(Customer.count).to eq 4
      end
    end

    context 'when file is a psv' do
      it 'creates Customer and Vehicle objects' do
        described_class.parse('spec/file_fixtures/pipes.txt')

        expect(Vehicle.count).to eq Customer.count
      end

      it 'creates using multiple files' do
        described_class.parse('spec/file_fixtures/pipes.txt')
        described_class.parse('spec/file_fixtures/pipes_2.txt')

        expect(Vehicle.count).to eq 6
      end

      it 'does not create duplicate customers' do
        described_class.parse('spec/file_fixtures/pipes.txt')
        described_class.parse('spec/file_fixtures/pipes_2.txt')

        expect(Customer.count).to eq 4
      end
    end
  end
end
