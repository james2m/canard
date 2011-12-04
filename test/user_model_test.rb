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

  describe "scopes" do
    
    before do
      @no_role             = User.create
      @admin_author_viewer = User.create(:roles => [:admin, :author, :viewer])
      @author_viewer       = User.create(:roles => [:author, :viewer])
      @viewer              = User.create(:roles => [:viewer])
    end
    
    after do
      User.delete_all
    end
    
    describe "on models with roles" do
      
      subject { User }
      
      it "should add a scope to return instances with each role" do
        subject.must_respond_to :admins
        subject.must_respond_to :authors
        subject.must_respond_to :viewers
      end
      
      it "should add a scope to return instances without each role" do
        subject.must_respond_to :non_admins
        subject.must_respond_to :non_authors
        subject.must_respond_to :non_viewers
      end
      
      describe "finding instances with a role" do
        
        describe "admins scope" do

          subject { User.admins }

          it "should return only admins" do
            subject.must_equal [@admin_author_viewer]
          end

          it "should not return non admins" do
            subject.wont_include @no_role
            subject.wont_include @author_viewer
            subject.wont_include @viewer
          end

        end

        describe "authors scope" do

          subject { User.authors }

          it "should return only authors" do
            subject.must_equal [@admin_author_viewer, @author_viewer]
          end

          it "should not return non authors" do
            subject.wont_include @no_role
            subject.wont_include @viewer
          end

        end

        describe "viewers scope" do

          subject { User.viewers }

          it "should return only viewers" do
            subject.must_equal [@admin_author_viewer, @author_viewer, @viewer]
          end

          it "should not return non authors" do
            subject.wont_include @no_role
          end

        end

      end
      
      describe "finding instances without a role" do
        
        describe "non_admins scope" do

          subject { User.non_admins }

          it "should return only non_admins" do
            subject.must_equal [@no_role, @author_viewer, @viewer]
          end

          it "should not return admins" do
            subject.wont_include @admin_author_viewer
          end

        end

        describe "non_authors scope" do

          subject { User.non_authors }

          it "should return only non_authors" do
            subject.must_equal [@no_role, @viewer]
          end

          it "should not return authors" do
            subject.wont_include @admin_author_viewer
            subject.wont_include @author_viewer
          end

        end

        describe "non_viewers scope" do

          subject { User.non_viewers }

          it "should return only non_viewers" do
            subject.must_equal [@no_role]
          end

          it "should not return viewers" do
            subject.wont_include @admin_author_viewer
            subject.wont_include @author_viewer
            subject.wont_include @viewer
          end

        end

      end
      
    end

  end
  
end
