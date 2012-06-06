module Canard

  class << self
    # A string specifying the location that should be searched for ability
    # definitions. By default, Canard will attempt to load abilities from
    # Rails.root + /abilities/.
    attr_writer :abilities_path
    
    def abilities_path 
      @abilities_path ||= 'abilities'
    end
    
    def ability_definitions
      Abilities.definitions
    end
    
    def abilities_for(role, &block)
      ::ActiveSupport::Deprecation.warn("abilities_for is deprecated and will be removed from Canard 0.4.0. Use Canard::Abilities.for and move the definitions to app/abilities.")
      ability_definitions[role] = block
    end

  end

  def self.load_paths
    Abilities.definition_paths.map { |path| File.expand_path(path) }
  end

  # TODO remove at version 0.4.0
  def self.find_abilities #:nodoc:
    absolute_abilities_path = File.expand_path(abilities_path)

    if File.directory? absolute_abilities_path
      Dir[File.join(absolute_abilities_path, '**', '*.rb')].sort.each do |file|
        self.class_eval File.read(file)
      end
    end
    
    load_paths.each do |path|
      Dir[File.join(path, '**', '*.rb')].sort.each do |file|
        load file
      end
    end

  end
  
end