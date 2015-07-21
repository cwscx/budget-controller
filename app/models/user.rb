class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
  has_many :consumptions
  has_many  :budgets
  
  def hasConsumptions?
    @all_consumptions = consumptions.find_by_user_id(self.id)
    if(@all_consumptions.nil?)
      false
    else
      @all_consumptions
    end
  end
  
  def hasBudget?
    # Get the latest budget plan
    @budget = budgets.order('end_time').last

    # If the there's no budget plan setted or the latest budget plan is not in use
    # Return false to indicate that here's no valid budget plan currently
    if(@budget.nil? || @budget.end_time.nil? || !@budget.end_time.future?)
      false
    else
      @budget
    end
  end
  
end
