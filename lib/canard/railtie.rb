# frozen_string_literal: true

module Canard
  class Railtie < Rails::Railtie # :nodoc:
    initializer 'canard.no_eager_loading', before: 'before_eager_loading' do |app|
      ActiveSupport::Dependencies.autoload_paths.reject! { |path| Canard.load_paths.include?(path) }
      # Don't eagerload our configs, we'll deal with them ourselves
      app.config.eager_load_paths = app.config.eager_load_paths.reject do |path|
        Canard.load_paths.include?(path)
      end

      app.config.watchable_dirs.merge! Hash[Canard.load_paths.product([[:rb]])] if app.config.respond_to?(:watchable_dirs)
    end

    initializer 'canard.active_record' do |_app|
      ActiveSupport.on_load :active_record do
        require 'canard/adapters/active_record'
        Canard::Abilities.default_path = File.expand_path('app/abilities', Rails.root)
        extend Canard::UserModel
        Canard.find_abilities
      end
    end

    initializer 'canard.mongoid' do |_app|
      require 'canard/adapters/mongoid' if defined?(Mongoid)
    end

    initializer 'canard.abilities_reloading', after: 'action_dispatch.configure' do |_app|
      reloader = rails5? ? ActiveSupport::Reloader : ActionDispatch::Reloader
      reloader.to_prepare { Canard.find_abilities } if reloader.respond_to?(:to_prepare)
    end

    rake_tasks do
      load File.expand_path('../tasks/canard.rake', __dir__)
    end

    private

    def rails5?
      ActionPack::VERSION::MAJOR == 5
    end
  end
end
