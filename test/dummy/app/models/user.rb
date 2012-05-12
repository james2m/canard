class User < ActiveRecord::Base
  
  acts_as_user :roles => [:viewer, :author, :admin]
  
  attr_accessible :roles
end
