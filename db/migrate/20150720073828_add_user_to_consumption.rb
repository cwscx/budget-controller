class AddUserToConsumption < ActiveRecord::Migration
  def change
    add_column :consumptions, :user_id, :integer
    add_index  :consumptions, :user_id
  end
end
