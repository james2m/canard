require 'rubygems'
gem     'minitest'
require 'active_record'
require 'minitest/autorun'
require 'pathname'

module Rails
  
  module VERSION
    MAJOR = 0
  end
  
  def self.root
    Pathname.new(File.expand_path('..', __FILE__))
  end
end

module MiniTestWithHooks
  class Unit < MiniTest::Unit
    def before_suites
    end

    def after_suites
    end

    def _run_suites(suites, type)
      begin
        before_suites
        super(suites, type)
      ensure
        after_suites
      end
    end
  end
end

module MiniTestWithActiveRecord
  class Unit < MiniTestWithHooks::Unit

    def before_suites
      super
      ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")
      ActiveRecord::Migration.verbose = false
      
      @migration  = Class.new(ActiveRecord::Migration) do

        def change
          create_table :users, :force => true do |t|
            t.string     :roles_mask
          end
          create_table :user_without_roles, :force => true do |t|
            t.string     :roles_mask
          end
          create_table :user_without_role_masks, :force => true do |t|
          end
        end

      end
      
      @migration.new.migrate(:up)
    end

    def after_suites
      @migration.new.migrate(:down)
      super
    end
  end
end

MiniTestWithActiveRecord::Unit::TestCase.add_teardown_hook do
  Object.send(:remove_const, 'Canard') if Object.const_defined?('Canard')
  GC.start
end

MiniTestWithActiveRecord::Unit::TestCase.add_setup_hook do
  [ 'canard/abilities.rb',
    'canard/user_model.rb',
    "canard/find_abilities.rb"
  ].each do |file|
    file_path = File.join(File.expand_path('../../lib', __FILE__), file)
    load file_path
  end
  
end

MiniTest::Unit.runner = MiniTestWithActiveRecord::Unit.new

