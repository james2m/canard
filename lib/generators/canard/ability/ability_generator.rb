module Canard
  module Generators
    class AbilityGenerator < Rails::Generators::NamedBase
    
      source_root File.expand_path('../templates', __FILE__)
    
      argument :abilities, :type => :array, :default => [], :banner => "ability:model ability:model"

      def generate_ability
        template "abilities.rb.erb", "app/abilities/#{file_name}.rb"
      end
    
      hook_for :test_framework, :as => 'ability'
    
    end
  end
end