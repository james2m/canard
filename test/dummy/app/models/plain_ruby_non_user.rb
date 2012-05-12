class PlainRubyNonUser
  
  extend Canard::UserModel
  
  acts_as_user :roles => [:viewer, :author, :admin]
  
end
