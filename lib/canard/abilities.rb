module Canard
  class Abilities
  
    @definitions = {}
    @definition_paths = ['app/abilities']

    class << self

      attr_accessor :definition_paths
      
      attr_reader :definitions
      
      def define(name, &block)
        raise ArgumentError.new('No block of ability definitions given') unless block_given?
        @definitions[name.to_sym] = block
      end
      
    end
    
  end
  
end