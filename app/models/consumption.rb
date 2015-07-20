class Consumption < ActiveRecord::Base
  belongs_to :user
  validates_presense_of :name
  validates_presense_of :price
  validates_presense_of :date
  
  validates_numericality_of :price
  
end
