class BudgetsController < ApplicationController
  
  before_action :set_budget, :only => [:edit, :update]
  def index
  end
  
  def new
    @budget = Budget.new(user_id: current_user.id)
  end
  
  def create
    # If the current user's has or used to have a budget, return the budget. Outdated budget will be updated automatically
    if @budget = current_user.hasBudget?
      @budget
      flash[:notice] = "Budget already exists"
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
      
      flash[:notice] = "New budget is already managed"
    end
    
    redirect_to :root
  end
  
  def show
    @budget = Budget.find(params[:id])
    start_time = @budget.created_at
    end_time = @budget.end_time

    @consumptions = current_user.consumptions.where("created_at >= ? AND created_at <= ?", start_time, end_time)
    
    @remaining = @budget.amount
    @consumptions.each do |c|
      @remaining -= c.price
    end
  end
  
  def edit
  end
  
  def update
    if(budget_params[:amount].to_f >= 0)
      @budget.update(budget_params)
      
      flash[:notice] = "The budget is updated!"
      redirect_to :root
    else
      flash[:alert] = 'The new budget should be positive'
      render :action => :edit
    end
  end
  
  private 

  # get amount
  def budget_params
    params.require(:budget).permit(:amount)
  end
  
  # Return the user's latest valid budget plan
  def set_budget
    @budget = current_user.hasBudget?
  end
end
