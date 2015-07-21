class ConsumptionDateDeleted < ActiveRecord::Migration
  def change
    remove_column :consumptions, :time
  end
end
