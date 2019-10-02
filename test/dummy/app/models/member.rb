# frozen_string_literal: true

class Member < ActiveRecord::Base
  belongs_to :user

  attr_accessible :user, :user_id
end
