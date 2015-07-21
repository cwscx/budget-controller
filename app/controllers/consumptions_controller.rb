class ConsumptionsController < ApplicationController
  before_filter:authenticate_user!
  
  before_action :set_consumptions, :only => [:index, :edit, :update, :destroy]
  
  def index
  end
  
  def new
    @consumption = Consumption.new(user_id: current_user.id)
  end
  
  def create
    @consumption = Consumption.create(user_id: current_user.id)
    @consumption.name = consumption_params[:name]
    @consumption.price = consumption_params[:price]
    @consumption.save
    
    redirect_to :root
  end
  
  def edit
  end
  
  def update
    if(!consumption_params[:name].nil? && consumption_params[:name] != '' && consumption_params[:price].to_f > 0)
      if(@consumptions.find(params[:id]).update(consumption_params))
        redirect_to :root
      else
        render :action => :edit
      end
    else
      render :action => :edit
    end
  end
  
  def destroy
    @consumptions.find(params[:id]).destroy
    redirect_to :root
  end
  
  private
  
  def set_consumptions
    @consumptions = current_user.hasConsumptions?
  end
  
  def consumption_params
    params.require(:consumption).permit(:name, :price)
  end
end
