require 'test_helper'
require 'canard'

describe Canard::UserModel do
  
  before do
    Canard.abilities_path = 'abilities'
    require 'models/user'
    require 'models/user_without_role'
    require 'models/user_without_role_mask'
  end
  
  # Sanity test
  it "must be an user" do
    user = User.new
    user.must_be_instance_of User
    user = UserWithoutRole.new
    user.must_be_instance_of UserWithoutRole
    user = UserWithoutRoleMask.new
    user.must_be_instance_of UserWithoutRoleMask
  end
  
  describe 'acts_as_user' do
    
    it 'should add role_model to this model' do
      User.included_modules.must_include RoleModel
      User.must_respond_to :roles
    end
    
    describe 'on a model with a role mask' do
      
      describe 'and :roles => [] specified' do
      
        it 'should set the valid_roles for the class' do
          User.valid_roles.must_equal [:admin, :author, :viewer]
        end
        
      end
      
      describe 'with no :roles => [] specified' do
        
        it 'should not set any roles' do
          UserWithoutRole.valid_roles.must_equal []
        end
      end
      
    end
      
    describe 'with no roles_mask' do
      
      it 'should not set any roles' do
        UserWithoutRole.valid_roles.must_equal []
      end
    end
    
  end

end