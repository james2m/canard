module Canard

  def self.ability_definitions
    Abilities.definitions
  end

  def self.ability_key(class_name)
    klass_name = String(class_name)
    klass_name.gsub!('::', '')
    klass_name.gsub!(/(.)([A-Z])/,'\1_\2')
    klass_name.downcase!
    klass_name.to_sym
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