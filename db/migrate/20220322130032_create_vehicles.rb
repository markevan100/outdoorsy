class CreateVehicles < ActiveRecord::Migration[6.0]
  def change
    create_table :vehicles do |t|
      t.string :name
      t.string :category
      t.float :length
      t.boolean :primary

      t.references :customer
      t.timestamps
    end
  end
end
