require 'generators/rspec'
require_relative '../../ability_definition'

module Rspec
  module Generators
    class AbilityGenerator < Base
      @_rspec_source_root = File.expand_path('../templates', __FILE__)
      argument :ability_definitions, :type => :array, :default => [], :banner => "can:abilities:models cannot:abilities:models"

      def generate_ability_spec
        template "abilities_spec.rb.erb", "spec/abilities/#{file_name.pluralize}_spec.rb"
      end
      
      private
      
      def definitions(&block)
        ability_definitions.each { |definition| AbilityDefinition.parse(definition) }
        
        AbilityDefinition.models.sort.each do |model, definition|
          yield model, definition
        end
      end
      
    end
    
  end
end
