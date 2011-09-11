require 'active_support/inflector'

class AbilityDefinition
  
  attr_accessor :cans, :cannots
  
  def self.parse(definitions)
    @@ability_definitions ||= {}
    limitation, ability_names, model_names = *definitions.split(':')
    abilities, models = extract(ability_names), extract(model_names)
    models.each do |model|
      definition = @@ability_definitions[model] || AbilityDefinition.new
      definition.merge(limitation.pluralize, abilities)
      @@ability_definitions[model] = definition
    end
  end
  
  def self.extract(string)
    return *string.gsub(/[\[\]\s]/, '').split(',')
  end
    
  def self.models
    @@ability_definitions
  end
  
  def initialize
    @cans, @cannots = [], []
  end
  
  def merge(limitation, abilities)
    combined_abilities = instance_variable_get("@#{limitation}") | abilities
    instance_variable_set("@#{limitation}", combined_abilities)
  end
  
  def can
    @cans
  end
  
  def cannot
    @cannots
  end
      
end
