class ConsumptionsController < ApplicationController
  before_filter:authenticate_user!
  
  before_action :set_consumptions, :only => [:index, :edit, :update, :destroy]
  before_action :set_budgets, :only => [:index]
  
  def index
    if(current_user.hasConsumptions?)
      @remaining = current_user.remaining_budget

      if(@remaining == 0)
        flash[:notice] = "You have no budget right now!"
      elsif(@remaining < 0)
        flash[:alert] = "You budget is less than zero!"
      end
    end
  end
  
  def new
    @consumption = Consumption.new(user_id: current_user.id)
  end
  
  def create
    if(@consumption = Consumption.create(user_id: current_user.id))
      if(consumption_params[:name].nil? || consumption_params[:name] == '')
        flash[:alert] = "The consumption's must be described"
        render :action => :new
      elsif(consumption_params[:price].to_f < 0)
        flash[:alert] = "The consumption's price cannot be negative"
        render :action => :new
      else
        @consumption.name = consumption_params[:name]
        @consumption.price = consumption_params[:price]
        @consumption.save
    
        flash[:notice] = "A new consumption added!"
        redirect_to :root
      end

    else
      flash[:alert] = "Error! This consumption cannot be created"
      render :action => :new
    end
  end
  
  def edit
  end
  
  def update
    if(consumption_params[:name].nil? || consumption_params[:name] == '')
      flash[:alert] = "The consumption's must be described"
      render :action => :edit
    elsif(consumption_params[:price].to_f < 0)
      flash[:alert] = "The consumption's price cannot be negative"
      render :action => :edit
    else
      if(@consumptions.find(params[:id]).update(consumption_params))
        flash[:notice] = "This consumption is updated successfully"
        redirect_to :root
      else
        flash[:alert] = "Error! This consumption cannot be updated"
        render :action => :edit
      end
    end
  end
  
  def destroy
    @consumptions.find(params[:id]).destroy
    flash[:notice] = "The consumption is deleted"
    redirect_to :root
  end
  
  private
  
  def set_consumptions
    @consumptions = current_user.hasConsumptions?
  end
  
  def set_budgets
    @budgets = current_user.budgets.order('end_time DESC')
  end
  
  def consumption_params
    params.require(:consumption).permit(:name, :price)
  end
end
