# frozen_string_literal: true

class UserWithoutRoleMask < ActiveRecord::Base
  attr_accessible :roles
end
