class ChangeListingTypeDefaultInProperties < ActiveRecord::Migration[7.2]
  def change
    change_column_default :properties, :listing_type, from: "sale", to: "sell"
  end
end
