class CreateOrderItems < ActiveRecord::Migration[7.1]
  def change
    create_table :order_items do |t|
      t.integer :quantity
      t.decimal :price, precision: 10, scale: 2
      t.references :order, null: false, foreign_key: true

      t.timestamps
    end
  end
end
