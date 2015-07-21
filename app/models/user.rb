class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
  has_many :consumptions
  has_many  :budgets
  
  def hasConsumptions?
    if(self.hasBudget?)
      time = @budget.created_at
      @consumptions = consumptions.where("created_at >= ?", time)

      if(@consumptions.nil?)
        false
      else
        @consumptions
      end
    else
      false
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
  
  # Calcualte the remaining Budget
  def remaining_budget
    # If there're valid consumptions and budget, calculating the remaining budget
    if(self.hasConsumptions?)
      @remaining = @budget.amount
      
      @consumptions.each do |c|
        @remaining -= c.price
      end
      
      @remaining
    # If there's invalid consumptions but valid budget, direct to new consumption page
    elsif(self.hasBudget?)
      redirect_to new_consumption_url(self.id)
    # If nothing's valid, redirect to new budget page
    else
      redirect_to new_budget.url(self.id)
    end
  end
end
