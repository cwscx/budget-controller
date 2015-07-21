class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
  has_many :consumptions
  has_many  :budgets
  
  def hasConsumptions?
    if(self.hasBudget?)
      start_time = @budget.created_at
      end_time = @budget.end_time
      puts start_time
      puts end_time
      @consumptions = consumptions.where("created_at >= ? AND created_at <= ?", start_time, end_time)

      if(@consumptions.nil? || @consumptions.length == 0)
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

    # If the there's no budget plan setted, return false to indicate that here's no budget plan.
    # Usually it's the case when the user first login
    if(@budget.nil? || @budget.end_time.nil?)
      false
    else
      # If the user's current budget plan is invalid, create a new plan for the user automatically
      if(!@budget.end_time.future?)
        @budget = Budget.create(user_id: @budget.user_id, amount: @budget.amount)
        
        # Set the end time as one month later
        @end_time = @budget.created_at
        if(@end_time.month == 12)
          @end_time = @end_time.change(year: @end_time.year + 1, month: 0)
        else
          @end_time = @end_time.change(month: @end_time.month + 1)
        end
    
        @budget.end_time = @end_time
        @budget.save
      end
      
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
      @budget.amount
    end
  end
end
