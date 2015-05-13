require 'test_helper'

describe Canard do

  describe "find_abilities" do

    before do
      Canard::Abilities.definition_paths = [File.expand_path('../../dummy/app/abilities', __FILE__)]
    end

    it "loads the abilities into ability_definitions" do
      Canard.find_abilities

      Canard.ability_definitions.keys.must_include :admin
    end

    it "finds abilities in the default path" do
      Canard.find_abilities

      Canard.ability_definitions.keys.must_include :author
      Canard.ability_definitions.keys.wont_include :administrator
    end

    it "finds abilities in additional paths" do
      Canard::Abilities.definition_paths << File.expand_path('../../abilities', __FILE__)
      Canard.find_abilities

      Canard.ability_definitions.keys.must_include :author
      Canard.ability_definitions.keys.must_include :administrator
    end

    it "reloads existing abilities" do
      Canard.find_abilities
      Canard::Abilities.send(:instance_variable_set, '@definitions', {})
      Canard.find_abilities

      Canard.ability_definitions.keys.must_include :author
      Canard.ability_definitions.keys.must_include :admin
    end

  end

end
