module Canard

  class << self
    def ability_definitions
      Abilities.definitions
    end
  end

  def self.load_paths
    Abilities.definition_paths.map { |path| File.expand_path(path) }
  end

  def self.find_abilities #:nodoc:
    load_paths.each do |path|
      Dir[File.join(path, '**', '*.rb')].sort.each do |file|
        load file
      end
    end

  end

end