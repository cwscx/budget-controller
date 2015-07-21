class UserCreatedAddedTime < ActiveRecord::Migration
  def change
    add_column :budgets, :end_time, :date, null: false
  end
end
