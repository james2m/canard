require 'active_support/inflector'

class AbilityDefinition
  
  attr_accessor :cans, :cannots
  
  def self.parse(definitions)
    @@ability_definitions ||= {}
    limitation, ability_list, model_list = *definitions.split(':')
    ability_names, model_names = extract(ability_list), extract(model_list)
    model_names.each do |model_name|
      definition = @@ability_definitions[model_name] || AbilityDefinition.new
      definition.merge(limitation.pluralize, ability_names)
      @@ability_definitions[model_name] = definition
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
  
  def merge(limitation, ability_names)
    combined_ability_names = instance_variable_get("@#{limitation}") | ability_names
    instance_variable_set("@#{limitation}", combined_ability_names)
  end
  
  def can
    @cans
  end
  
  def cannot
    @cannots
  end
      
end
