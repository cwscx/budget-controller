class Consumption < ActiveRecord::Base
  belongs_to :user, :foreign_key => 'user_id'
  
  validates_numericality_of :price
end
