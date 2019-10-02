# frozen_string_literal: true

require_relative '../../ability_definition'

module Canard
  module Generators
    class AbilityGenerator < Rails::Generators::NamedBase # :nodoc:
      source_root File.expand_path('templates', __dir__)
      argument :ability_definitions,
               type: :array,
               default: [],
               banner: 'can:[read,update]:[user,account] cannot:[create,destroy]:user'

      def generate_ability
        template 'abilities.rb.erb', Abilities.default_path + "/#{file_name.pluralize}.rb"
      end

      hook_for :test_framework, as: 'ability'

      private

      def definitions
        ability_definitions.each { |definition| AbilityDefinition.parse(definition) }

        AbilityDefinition.models.sort.each do |model, definition|
          yield model, definition
        end
      end
    end
  end
end
