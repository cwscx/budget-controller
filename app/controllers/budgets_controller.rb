class BudgetsController < ApplicationController
  
  def index
  end
  
  def new
    @budget = Budget.new(user_id: current_user.id)
  end
  
  def create
    # If the current user's budget plan is still valid, return the budget
    if @budget = current_user.hasBudget?
      @budget
    # create a new budget plan with the enetered amount and end time
    else
      @budget = Budget.create(amount: params[:budget][:amount], user_id: current_user.id)
    
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
    
    redirect_to :root
  end
  
  def edit
    
  end
end
