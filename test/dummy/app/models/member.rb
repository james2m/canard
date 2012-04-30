class Member < ActiveRecord::Base
    
  belongs_to :user
  
  attr_accessible :user, :user_id
  
end
