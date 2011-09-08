require 'test_helper'
require_relative '../lib/canard.rb'

describe Canard do
  
  before do
    class User < ActiveRecord::Base
    end
  
    Canard.abilities_path = File.expand_path('../abilities', __FILE__)
  end
  
  # Sanity test
  it "must be an user" do
    user = User.new
    user.must_be_instance_of User
  end
  
  describe "abilities_path" do
    
    it "should be mutable" do
      Canard.abilities_path = 'app/abilities'
      Canard.abilities_path.must_equal 'app/abilities'
    end

  end
  
  describe "ability_definitions" do
    
    it "should be an accessor" do
      Canard.must_respond_to(:ability_definitions)
    end
    
    it "should be a hash" do
      Canard.ability_definitions.must_be_instance_of Hash
    end
    
  end  
  
  describe "find_abilities" do
    
    it "should load the abilities into ability_definitions" do
      Canard.find_abilities

      Canard.ability_definitions.keys.must_include :admin
    end
    
  end
  
end
