require 'test_helper'
require 'canard'

describe Canard do
  
  before do
    Canard.abilities_path = File.expand_path('../abilities', __FILE__)
  end
  
  describe "find_abilities" do
    
    it "should load the abilities into ability_definitions" do
      Canard.find_abilities

      Canard.ability_definitions.keys.must_include :admin
    end
    
  end
end
