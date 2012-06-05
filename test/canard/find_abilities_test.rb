require 'test_helper'
require 'active_support/testing/deprecation'

describe Canard do
  
  include ActiveSupport::Testing::Deprecation
  
  before do
    # Stop the deprecation warnings coming to stderr for these tests.
    ActiveSupport::Deprecation.behavior = :notify
    
    Canard.abilities_path = File.expand_path('../abilities', __FILE__)
  end
  
  describe "find_abilities" do
    
    it "loads the abilities into ability_definitions" do
      Canard.find_abilities

      Canard.ability_definitions.keys.must_include :admin
    end
    
    it "finds the abilities with the new syntax" do
      Canard.find_abilities
      
      Canard.ability_definitions.keys.must_include :author
    end
    
    it "reloads existing abilities" do
      Canard.find_abilities
      Canard::Abilities.send(:instance_variable_set, '@definitions', {})
      Canard.find_abilities
      
      Canard.ability_definitions.keys.must_include :author
      Canard.ability_definitions.keys.must_include :admin
    end
    
  end
  
  describe "abilities_for" do
    
    it "raises a deprecation warning" do
      assert_deprecated do
        Canard.abilities_for(:this) { return 'that' }
      end
    end
    
  end
end
