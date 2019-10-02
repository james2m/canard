# frozen_string_literal: true

class UserWithoutRole < ActiveRecord::Base
  acts_as_user

  attr_accessible :roles
end
