# frozen_string_literal: true

class User < ActiveRecord::Base
  acts_as_user roles: %i[viewer author admin editor]

  attr_accessible :roles
end
