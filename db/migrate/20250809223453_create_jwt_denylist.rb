class CreateJwtDenylist < ActiveRecord::Migration[7.2]
  def change
    create_table :jwt_denylists do |t|
      t.timestamps
      t.string :jti, null: false
      t.datetime :exp, null: false
      t.index :jti, unique: true
    end
  end
end
