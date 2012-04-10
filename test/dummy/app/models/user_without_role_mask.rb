class UserWithoutRoleMask < ActiveRecord::Base

  extend Canard::UserModel
  acts_as_user 

  attr_accessible :roles
end