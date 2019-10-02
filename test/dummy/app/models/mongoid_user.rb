# frozen_string_literal: true

class MongoidUser
  include Mongoid::Document

  acts_as_user roles: %i[viewer author admin]
end
