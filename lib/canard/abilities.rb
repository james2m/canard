# frozen_string_literal: true

module Canard
  class Abilities # :nodoc:
    @definitions  = {}
    @default_path = 'app/abilities'

    class << self
      extend Forwardable

      def_delegators :Canard, :ability_key

      attr_accessor :default_path

      attr_writer :definition_paths

      attr_reader :definitions

      def definition_paths
        @definition_paths ||= [@default_path]
      end

      def for(name, &block)
        raise ArgumentError, 'No block of ability definitions given' unless block_given?

        key = ability_key(name)
        @definitions[key] = block
      end
    end
  end
end
