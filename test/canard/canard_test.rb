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

  describe "ability_key" do

    it "returns a snake case version of the string" do
      class_name = 'CamelCaseString'
      key = :camel_case_string

      Canard.ability_key(class_name).must_equal key
    end

    it "prepends namespaces to the class name" do
      class_name = 'Namespace::CamelCaseString'
      key = :namespace_camel_case_string

      Canard.ability_key(class_name).must_equal key
    end
  end
end
