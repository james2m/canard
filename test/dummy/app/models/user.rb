class User < ActiveRecord::Base

  acts_as_user :roles => [:viewer, :author, :admin, :editor]

  attr_accessible :roles
end
