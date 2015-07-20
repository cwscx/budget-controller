class ConsumptionAddNotNull < ActiveRecord::Migration
  def change
    change_column :consumptions, :name, :string, null: false
    change_column :consumptions, :price, :float, null: false
    change_column :consumptions, :time, :date, null: false
    change_column :consumptions, :user_id, :integer, null: false
  end
end
