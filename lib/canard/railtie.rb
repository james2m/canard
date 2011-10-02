require 'canard'
require 'rails'

module Canard
  class Railtie < Rails::Railtie
    
    initializer "canard.active_record" do |app|
      ActiveSupport.on_load :active_record do
        extend Canard::UserModel
        Canard.abilities_path ||= File.expand_path('abilities', Rails.root)
        Canard.find_abilities
      end
    end
    
    initializer "canard.abilities_reloading", :after => "action_dispatch.configure" do |app|
      ActionDispatch::Reloader.to_prepare { Canard.find_abilities }
    end
    
  end
end