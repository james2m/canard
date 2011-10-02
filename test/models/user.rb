class User < ActiveRecord::Base
  extend Canard::UserModel
  acts_as_user :roles => [:admin, :author, :viewer]
end
