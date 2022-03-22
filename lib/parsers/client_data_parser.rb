require 'csv'

class ClientDataParser
  CUSTOMER_KEYS = %i[first_name last_name email]
  VEHICLE_KEYS = %i[category name length]

  class << self
    def parse(file)
      col_sep = nil
      IO.foreach(file) do |row|
        col_sep ||= row.include?(',') ? ',' : '|'
        customer_vehicle_data = CSV.parse(row, col_sep: col_sep, headers: CUSTOMER_KEYS + VEHICLE_KEYS)

        create_objects(customer_vehicle_data)
      end
    end

    private

    def create_objects(customer_vehicle_data)
      customer_vehicle_data.each do |attributes|
        customer_attributes = attributes.to_h.slice(*CUSTOMER_KEYS)
        initial_vehicle_attributes = attributes.to_h.slice(*VEHICLE_KEYS)

        sanitized_vehicle_attributes = sanitize_vehicle_data(initial_vehicle_attributes)
        customer = Customer.find_or_create_by(customer_attributes)
        Vehicle.find_or_create_by(sanitized_vehicle_attributes.merge(customer: customer,
                                                                     primary: customer.vehicles.empty?))
      end
    end

    def sanitize_vehicle_data(vehicle_attributes)
      vehicle_attributes[:length] = vehicle_attributes[:length].to_f
      vehicle_attributes[:category] = vehicle_attributes[:category].downcase
      vehicle_attributes
    end
  end
end
