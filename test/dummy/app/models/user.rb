class User < ActiveRecord::Base
  
  extend Canard::UserModel
  
  acts_as_user :roles => [:viewer, :author, :admin]
  
  attr_accessible :roles
end
