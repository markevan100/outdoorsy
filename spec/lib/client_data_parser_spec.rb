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

        expect(Vehicle.count).to eq 7
      end

      it 'does not create duplicate customers' do
        described_class.parse('spec/file_fixtures/pipes.txt')
        described_class.parse('spec/file_fixtures/pipes_2.txt')

        expect(Customer.count).to eq 5
      end
    end
  end

  describe 'sort and return data with scopes' do
    context 'when borrowers and vehicles are present' do
      it 'sorts customers by vehicle type asc by default' do
        described_class.parse('spec/file_fixtures/pipes.txt')
        data = Customer.by_vehicle_type

        expect(data.first.first_name).to eq 'Naomi'
      end

      it 'sorts customers by vehicle type desc when present' do
        described_class.parse('spec/file_fixtures/pipes.txt')
        data = Customer.by_vehicle_type('desc')

        expect(data.first.first_name).to eq 'Steve'
      end

      it 'sorts customers by full name' do
        described_class.parse('spec/file_fixtures/pipes_2.txt')
        data = Customer.by_full_name

        expect(data.last.last_name).to eq 'Uemura'
      end
    end
  end
end
