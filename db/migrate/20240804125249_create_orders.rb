class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      t.integer :status, default: 0
      t.decimal :total_price, precision: 10, scale: 2
      t.references :visitor, null: false, foreign_key: { to_table: :users }
      t.references :restaurant, null: false, foreign_key: true

      t.timestamps
    end
  end
end
