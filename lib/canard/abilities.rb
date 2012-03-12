module Canard
  class Abilities
  
    @definitions      = {}
    @default_path     = 'app/abilities'

    class << self

      attr_accessor :default_path
      
      attr_writer :definition_paths
      
      attr_reader :definitions
      
      def definition_paths
        @definition_paths ||= [@default_path]
      end
      
      def for(name, &block)
        raise ArgumentError.new('No block of ability definitions given') unless block_given?
        @definitions[name.to_sym] = block
      end
      
    end
    
  end
  
end
