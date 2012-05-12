class UserWithoutRoleMask < ActiveRecord::Base

  acts_as_user 

  attr_accessible :roles
end