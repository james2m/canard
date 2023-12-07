# frozen_string_literal: true

class PlainRubyUser
  extend Canard::UserModel

  attr_accessor :roles_mask

  def initialize(*roles)
    self.roles = roles
  end
end
