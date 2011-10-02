require 'rubygems'
gem     'minitest'
require 'active_record'
require 'minitest/autorun'

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

MiniTest::Unit.runner = MiniTestWithActiveRecord::Unit.new