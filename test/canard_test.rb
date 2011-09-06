require 'test_helper'
require 'canard'

describe Canard do
  
  before do
    class User < ActiveRecord::Base
    end
  
    @user = User.new
  end
  
  # Sanity test
  it "must be an user" do
    @user.must_be_instance_of User
  end
  
end
