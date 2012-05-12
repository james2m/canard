class PlainRubyUser
  
  extend Canard::UserModel
  
  attr_accessor :roles_mask
  
  acts_as_user :roles => [:viewer, :author, :admin]
  
end