class CreateConsumptions < ActiveRecord::Migration
  def change
    create_table :consumptions do |t|
      t.string :name
      t.float :price
      t.date :time

      t.timestamps null: false
    end
  end
end
