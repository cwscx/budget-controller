class Budget < ActiveRecord::Base
  belongs_to :user, :foreign_key => 'user_id'
  
  validates_numericality_of :amount
end
