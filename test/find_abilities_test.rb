require 'test_helper'
require 'active_support/testing/deprecation'

describe Canard do
  
  include ActiveSupport::Testing::Deprecation
  
  before do
    Canard.abilities_path = File.expand_path('../abilities', __FILE__)
  end
  
  describe "find_abilities" do
    
    it "should load the abilities into ability_definitions" do
      Canard.find_abilities

      Canard.ability_definitions.keys.must_include :admin
    end
    
  end
  
  describe "abilities_for" do
    
    it "should raise a deprecation warning" do
      assert_deprecated do
        Canard.abilities_for(:this) { puts 'that' }
      end
    end
    
  end
end
