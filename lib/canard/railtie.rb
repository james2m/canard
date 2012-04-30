require 'canard'
require 'rails'

module Canard
  class Railtie < Rails::Railtie
    
    initializer "canard.active_record" do |app|
      ActiveSupport.on_load :active_record do
        extend Canard::UserModel
        Canard.find_abilities
      end
    end
    
    initializer "canard.abilities_reloading", :after => "action_dispatch.configure" do |app|
      if ActionDispatch::Reloader.respond_to?(:to_prepare)
        ActionDispatch::Reloader.to_prepare { Canard.find_abilities }
      else
        ActionDispatch::Reloader.before { Canard.find_abilities }
      end
    end
    
  end
end