require 'test_helper'

describe Canard::UserModel do

  describe 'acts_as_user' do

    describe "integrating RoleModel" do

      before do
        PlainRubyUser.acts_as_user
      end

      it 'adds role_model to the class' do
        PlainRubyUser.included_modules.must_include RoleModel
        PlainRubyUser.new.must_respond_to :roles
      end
    end

    describe "with a roles_mask" do

      describe 'and :roles => [] specified' do

        before do
          PlainRubyUser.acts_as_user :roles => [:viewer, :author, :admin]
        end

        it 'sets the valid_roles for the class' do
          PlainRubyUser.valid_roles.must_equal [:viewer, :author, :admin]
        end
      end

      describe 'and no :roles => [] specified' do

        before do
          PlainRubyUser.acts_as_user
        end

        it 'sets no roles' do
          PlainRubyUser.valid_roles.must_equal []
        end
      end
    end

    describe "with no roles_mask" do

      before do
        PlainRubyNonUser.acts_as_user :roles => [:viewer, :author, :admin]
      end

      it "sets no roles" do
        PlainRubyNonUser.valid_roles.must_equal []
      end
    end

    describe "setting the role_mask" do

      before do
        PlainRubyNonUser.send :attr_accessor, :my_roles
        PlainRubyNonUser.acts_as_user :roles => [:viewer, :author], :roles_mask => :my_roles
      end

      it 'sets the valid_roles for the class' do
        PlainRubyNonUser.valid_roles.must_equal [:viewer, :author]
      end
    end
  end

  describe "scopes" do

    before do
      PlainRubyUser.acts_as_user :roles => [:viewer, :author, :admin]
    end

    describe "on a plain Ruby class" do

      subject { PlainRubyUser }

      it "creates no scope methods" do
        subject.wont_respond_to :admins
        subject.wont_respond_to :authors
        subject.wont_respond_to :viewers
        subject.wont_respond_to :non_admins
        subject.wont_respond_to :non_authors
        subject.wont_respond_to :non_viewers
        subject.wont_respond_to :with_any_role
        subject.wont_respond_to :with_all_roles
      end
    end
  end
end

describe Canard::UserModel::InstanceMethods do

  before do
    Canard::Abilities.default_path = File.expand_path('../../dummy/app/abilities', __FILE__)
    # reload abilities because the reloader will have removed them after the railtie ran
    Canard.find_abilities
  end

  describe "ability" do

    before do
      PlainRubyUser.acts_as_user :roles => [:admin, :author]
    end

    subject { PlainRubyUser.new(:author).ability }

    it "returns an ability for this instance" do
      subject.must_be_instance_of Ability
    end

    it "has the users abilities" do
      subject.can?(:new, Post).must_equal true
      subject.can?(:create, Post).must_equal true
      subject.can?(:edit, Post).must_equal true
      subject.can?(:update, Post).must_equal true
      subject.can?(:show, Post).must_equal true
      subject.can?(:index, Post).must_equal true
    end

    it "has no other abilities" do
      subject.cannot?(:destroy, Post).must_equal true
    end
  end
end
