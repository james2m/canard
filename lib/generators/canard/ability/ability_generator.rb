module Canard
  module Generators
    class AbilityGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)
      
      argument :ability_name, :type => :string, :default => "user"
      
      def generate_ability
        template "abilities.rb.erb", "app/abilities/#{file_name}.rb"
        template "abilities_spec.rb.erb", "spec/abliities/#{file_name}_spec.rb"
      end
      
      private

      def file_name
        ability_name.tableize
      end
    end
  end
end
