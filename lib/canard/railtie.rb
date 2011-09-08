require 'canard'
require 'rails'

module Canard
  class Railtie < Rails::Railtie
    
    initializer "canard.active_record" do |app|
      ActiveSupport.on_load :active_record do
        require 'canard/user'
        extend Canard::User
      end
    end
    
    initializer "canard.find_abilities" do |app|
      Canard.abilities_path ||= File.expand_path('app/abilities', Rails.root)
      Canard.find_abilities
    end
    
  end
end