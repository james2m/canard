class MongoidUser
  include Mongoid::Document
  
  acts_as_user :roles => [:viewer, :author, :admin]
end