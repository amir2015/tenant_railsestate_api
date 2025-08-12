class CreateProperties < ActiveRecord::Migration[7.2]
  def change
    create_table :properties do |t|
      t.string :title, null: false
      t.text :description
      t.string :property_type
      t.string :listing_type, null: false, default: "sale"
      t.decimal :price, precision: 15, scale: 2, null: false
      t.string :address, null: false
      t.string :city, null: false
      t.string :state
      t.string :zip_code
      t.string :country, null: false, default: "Egypt"
      t.decimal :lat, precision: 10, scale: 6
      t.decimal :lng, precision: 10, scale: 6
      t.integer :bedrooms
      t.decimal :bathrooms
      t.integer :square_feet
      t.decimal :lot_size
      t.integer :year_built
      t.string :status, null: false, default: "active"
      t.boolean :featured

      t.references :agent, null: false, foreign_key: { to_table: :users }
      t.references :company, null: false, foreign_key: true

      t.timestamps
    end

    add_index :properties, :status
    add_index :properties, [:lat, :lng]
    add_index :properties, :price
    add_index :properties, :property_type
  end
end
