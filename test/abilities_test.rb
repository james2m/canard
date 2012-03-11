require 'test_helper'
require 'canard'

describe 'Canard::Abilities' do

  subject { Canard::Abilities }
   
  describe "ability_paths" do
     
    it "defaults to app/abilities" do
      subject.definition_paths.must_include 'app/abilities'
    end
     
    it "appends paths" do
      subject.definition_paths << 'other_abilities'
      subject.definition_paths.must_include 'other_abilities'
    end

    it "can be overwritten" do
      subject.definition_paths = ['other_abilities']
      
      subject.definition_paths.must_equal ['other_abilities']
    end

  end
  
  describe "define" do
    
    it "adds the block to the definitions" do
      block = lambda { puts 'some block' }
      
      subject.for(:definition, &block)

      assert_equal block, subject.definitions[:definition]
    end
    
    it "normalises the key to a symbol" do
      subject.for('definition') { puts 'a block' }
      
      subject.definitions.keys.must_include :definition
    end
    
    it "rasises ArgumentError if no block is provided" do
      proc { subject.for(:definition) }.must_raise ArgumentError
    end
    
  end
      
end
