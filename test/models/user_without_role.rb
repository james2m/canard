class UserWithoutRole < ActiveRecord::Base
  extend Canard::UserModel
  acts_as_user 
end

