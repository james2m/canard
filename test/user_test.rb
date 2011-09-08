require 'test_helper'

describe Canard::User do
  
  before do
    class User < ActiveRecord::Base
      
      extend Canard::User
      
      attr_accessor :first_name, :last_name
      
      acts_as_user :roles => [:admin]
      
      def initialize(params={})
        self.first_name = params[:first_name]
        self.last_name  = params[:last_name]
      end
      
    end
  
    Canard.abilities_path = 'abilities'
  end
  
  # Sanity test
  it "must be an user" do
    user = User.new
    user.must_be_instance_of User
  end
  
  describe 'name' do
    it 'should return blank string if no name details entered' do
      user = User.new
      
      user.name.must_equal ''
      
    end

    it 'should return first_name if first_name only' do
      user = User.new(:first_name => 'Harvey', :last_name => nil)
      
      user.name.must_equal 'Harvey'
    end

    it 'should return last_name if last_name only' do
      user = User.new(:first_name => '', :last_name => 'Keitel')
      
      user.name.must_equal 'Keitel'
    end

    it 'should return first_name last_name if both details present' do
      user = User.new(:first_name => 'Calvin', :last_name => 'Broadus')
      
      user.name.must_equal 'Calvin Broadus'
    end
  end

end