class Consumption < ActiveRecord::Base
  belongs_to :user
  
  validates_numericality_of :price
end
