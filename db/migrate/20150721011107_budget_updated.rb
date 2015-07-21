class BudgetUpdated < ActiveRecord::Migration
  def change
    change_column :budgets, :user_id, :integer, null: false
    change_column :budgets, :end_time, :timestamp, null: true
  end
end
