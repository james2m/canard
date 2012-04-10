module MiniTest
  class Unit
    class TestCase
    
    def teardown
      Object.send(:remove_const, 'Canard') if Object.const_defined?('Canard')
      GC.start
    end
    
    def setup
      [ 'canard/abilities.rb',
        'canard/user_model.rb',
        "canard/find_abilities.rb"
      ].each do |file|
        file_path = File.join(File.expand_path('../../../lib', __FILE__), file)
        load file_path
      end
    end
  end

  end
end
