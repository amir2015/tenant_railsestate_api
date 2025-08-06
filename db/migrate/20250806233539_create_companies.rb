class CreateCompanies < ActiveRecord::Migration[7.2]
  def change
    create_table :companies do |t|
      t.string :name, null: false
      t.string :subdomain, null: false, index: { unique: true }
      t.string :logo_url
      t.jsonb :settings, default: {}
      t.string :plan_type
      t.string :address
      t.string :phone
      t.string :license_number
      t.string :website
      t.timestamps
    end
  end
end
