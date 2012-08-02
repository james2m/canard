require 'test_helper'
require 'canard'

describe Canard do

  describe "ability_definitions" do

    it "should be an accessor" do
      Canard.must_respond_to(:ability_definitions)
    end

    it "should be a hash" do
      Canard.ability_definitions.must_be_instance_of Hash
    end

  end

end
