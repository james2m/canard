require 'test_helper'

describe Canard::UserModel do

  describe 'acts_as_user' do

    describe "on a regular Ruby class" do

      describe "integrating RoleModel" do

        before do
          PlainRubyUser.acts_as_user
        end

        it 'adds role_model to the class' do
          PlainRubyUser.included_modules.must_include RoleModel
          PlainRubyUser.must_respond_to :roles
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

        it "sets no roles" do
          PlainRubyNonUser.valid_roles.must_equal []
        end
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
