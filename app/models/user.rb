class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
  has_many :consumptions
  
  def hasConsumptions?
    @all_consumptions = consumptions.find_by_user_id(self.id)
    if(@all_consumptions.nil?)
      false
    else
      @all_consumptions
    end
  end
  
end
