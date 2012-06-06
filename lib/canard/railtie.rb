require 'canard'
require 'rails'

module Canard
  class Railtie < Rails::Railtie
    
    initializer "carard.no_eager_loading", :before => 'before_eager_loading' do |app|
      ActiveSupport::Dependencies.autoload_paths.reject!{ |path| Canard.load_paths.include?(path) }
      # Don't eagerload our configs, we'll deal with them ourselves
      app.config.eager_load_paths = app.config.eager_load_paths.reject do |path|
        Canard.load_paths.include?(path)
      end
    end

    initializer "canard.active_record" do |app|
      ActiveSupport.on_load :active_record do
        Canard::Abilities.default_path = File.expand_path('app/abilities', Rails.root)
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