require 'test_helper'

describe Canard::Adapters::ActiveRecord do

  describe 'acts_as_user' do

    describe 'with a role_mask' do

      describe 'and :roles => [] specified' do

        it 'sets the valid_roles for the class' do
          User.valid_roles.must_equal [:viewer, :author, :admin, :editor]
        end

      end

      describe 'and no :roles => [] specified' do

        it 'sets no roles' do
          UserWithoutRole.valid_roles.must_equal []
        end
      end

    end

    describe 'with no roles_mask' do

      before do
        UserWithoutRoleMask.acts_as_user :roles => [:viewer, :admin]
      end

      it 'sets no roles' do
        UserWithoutRoleMask.valid_roles.must_equal []
      end
    end

    describe "with no table" do

      subject { Class.new(ActiveRecord::Base) }

      it "sets no roles" do
        subject.class_eval { acts_as_user :roles => [:admin] }
        subject.valid_roles.must_equal []
      end

      it "does not raise any errors" do
        proc { subject.class_eval { acts_as_user :roles => [:admin] } }.must_be_silent
      end

      it "returns nil" do
        subject.class_eval { acts_as_user :roles => [:admin] }.must_be_nil
      end
    end

    describe 'with an alternative roles_mask specified' do

      before do
        UserWithoutRoleMask.acts_as_user :roles_mask => :my_roles_mask, :roles => [:viewer, :admin]
      end

      it 'sets no roles' do
        UserWithoutRoleMask.valid_roles.must_equal [:viewer, :admin]
      end
    end

  end

  describe "scopes" do

    describe "on an ActiveRecord model with roles" do

      before do
        @no_role             = User.create
        @admin_author_viewer = User.create(:roles => [:admin, :author, :viewer])
        @author_viewer       = User.create(:roles => [:author, :viewer])
        @viewer              = User.create(:roles => [:viewer])
        @admin_only          = User.create(:roles => [:admin])
        @author_only         = User.create(:roles => [:author])
      end

      after do
        User.delete_all
      end

      subject { User }

      it "adds a scope to return instances with each role" do
        subject.must_respond_to :admins
        subject.must_respond_to :authors
        subject.must_respond_to :viewers
      end

      it "adds a scope to return instances without each role" do
        subject.must_respond_to :non_admins
        subject.must_respond_to :non_authors
        subject.must_respond_to :non_viewers
      end

      describe "finding instances with a role" do

        describe "admins scope" do

          subject { User.admins.sort_by(&:id) }

          it "returns only admins" do
            subject.must_equal [@admin_author_viewer, @admin_only].sort_by(&:id)
          end

          it "doesn't return non admins" do
            subject.wont_include @no_role
            subject.wont_include @author_viewer
            subject.wont_include @author_only
            subject.wont_include @viewer
          end

        end

        describe "authors scope" do

          subject { User.authors.sort_by(&:id) }

          it "returns only authors" do
            subject.must_equal [@admin_author_viewer, @author_viewer, @author_only].sort_by(&:id)
          end

          it "doesn't return non authors" do
            subject.wont_include @no_role
            subject.wont_include @admin_only
            subject.wont_include @viewer
          end

        end

        describe "viewers scope" do

          subject { User.viewers.sort_by(&:id) }

          it "returns only viewers" do
            subject.must_equal [@admin_author_viewer, @author_viewer, @viewer].sort_by(&:id)
          end

          it "doesn't return non authors" do
            subject.wont_include @no_role
            subject.wont_include @admin_only
            subject.wont_include @author_only
          end

        end

      end

      describe "finding instances without a role" do

        describe "non_admins scope" do

          subject { User.non_admins.sort_by(&:id) }

          it "returns only non_admins" do
            subject.must_equal [@no_role, @author_viewer, @viewer, @author_only].sort_by(&:id)
          end

          it "doesn't return admins" do
            subject.wont_include @admin_author_viewer
            subject.wont_include @admin_only
          end

        end

        describe "non_authors scope" do

          subject { User.non_authors.sort_by(&:id) }

          it "returns only non_authors" do
            subject.must_equal [@no_role, @viewer, @admin_only].sort_by(&:id)
          end

          it "doesn't return authors" do
            subject.wont_include @admin_author_viewer
            subject.wont_include @author_viewer
            subject.wont_include @author_only
          end

        end

        describe "non_viewers scope" do

          subject { User.non_viewers.sort_by(&:id) }

          it "returns only non_viewers" do
            subject.must_equal [@no_role, @admin_only, @author_only].sort_by(&:id)
          end

          it "doesn't return viewers" do
            subject.wont_include @admin_author_viewer
            subject.wont_include @author_viewer
            subject.wont_include @viewer
          end

        end

      end

      describe "with_any_role" do

        describe "specifying admin only" do

          subject { User.with_any_role(:admin).sort_by(&:id) }

          it "returns only admins" do
            subject.must_equal [@admin_author_viewer, @admin_only].sort_by(&:id)
          end

          it "doesn't return non admins" do
            subject.wont_include @no_role
            subject.wont_include @author_viewer
            subject.wont_include @author_only
            subject.wont_include @viewer
          end

        end

        describe "specifying author only" do

          subject { User.with_any_role(:author).sort_by(&:id) }

          it "returns only authors" do
            subject.must_equal [@admin_author_viewer, @author_viewer, @author_only].sort_by(&:id)
          end

          it "doesn't return non authors" do
            subject.wont_include @no_role
            subject.wont_include @admin_only
            subject.wont_include @viewer
          end

        end

        describe "specifying viewer only" do

          subject { User.with_any_role(:viewer).sort_by(&:id) }

          it "returns only viewers" do
            subject.must_equal [@admin_author_viewer, @author_viewer, @viewer].sort_by(&:id)
          end

          it "doesn't return non authors" do
            subject.wont_include @no_role
            subject.wont_include @admin_only
            subject.wont_include @author_only
          end

        end

        describe "specifying admin and author" do

          subject { User.with_any_role(:admin, :author).sort_by(&:id) }

          it "returns only admins and authors" do
            subject.must_equal [@admin_author_viewer, @author_viewer, @admin_only, @author_only].sort_by(&:id)
          end

          it "doesn't return non admins or authors" do
            subject.wont_include @no_role
            subject.wont_include @viewer
          end

        end

        describe "specifying admin and viewer" do

          subject { User.with_any_role(:admin, :viewer).sort_by(&:id) }

          it "returns only admins and viewers" do
            subject.must_equal [@admin_author_viewer, @author_viewer, @admin_only, @viewer].sort_by(&:id)
          end

          it "doesn't return non admins or viewers" do
            subject.wont_include @no_role
            subject.wont_include @author_only
          end

        end

        describe "specifying author and viewer" do

          subject { User.with_any_role(:author, :viewer).sort_by(&:id) }

          it "returns only authors and viewers" do
            subject.must_equal [@admin_author_viewer, @author_viewer, @author_only, @viewer].sort_by(&:id)
          end

          it "doesn't return non authors or viewers" do
            subject.wont_include @no_role
            subject.wont_include @admin_only
          end

        end

        describe "specifying admin, author and viewer" do

          subject { User.with_any_role(:admin, :author, :viewer).sort_by(&:id) }

          it "returns only admins, authors and viewers" do
            subject.must_equal [@admin_author_viewer, @author_viewer, @admin_only, @author_only, @viewer].sort_by(&:id)
          end

          it "doesn't return non admins, authors or viewers" do
            subject.wont_include @no_role
          end

        end

      end

      describe "with_all_roles" do

        describe "specifying admin only" do

          subject { User.with_all_roles(:admin).sort_by(&:id) }

          it "returns only admins" do
            subject.must_equal [@admin_author_viewer, @admin_only].sort_by(&:id)
          end

          it "doesn't return non admins" do
            subject.wont_include @no_role
            subject.wont_include @author_viewer
            subject.wont_include @author_only
            subject.wont_include @viewer
          end

        end

        describe "specifying author only" do

          subject { User.with_all_roles(:author).sort_by(&:id) }

          it "returns only authors" do
            subject.must_equal [@admin_author_viewer, @author_viewer, @author_only].sort_by(&:id)
          end

          it "doesn't return non authors" do
            subject.wont_include @no_role
            subject.wont_include @admin_only
            subject.wont_include @viewer
          end

        end

        describe "specifying viewer only" do

          subject { User.with_all_roles(:viewer).sort_by(&:id) }

          it "returns only viewers" do
            subject.must_equal [@admin_author_viewer, @author_viewer, @viewer].sort_by(&:id)
          end

          it "doesn't return non authors" do
            subject.wont_include @no_role
            subject.wont_include @admin_only
            subject.wont_include @author_only
          end

        end

        describe "specifying admin and author" do

          subject { User.with_all_roles(:admin, :author).sort_by(&:id) }

          it "returns only admins and authors" do
            subject.must_equal [@admin_author_viewer].sort_by(&:id)
          end

          it "doesn't return non admin and authors" do
            subject.wont_include @no_role
            subject.wont_include @author_viewer
            subject.wont_include @author_only
            subject.wont_include @admin_only
            subject.wont_include @viewer
          end

        end

        describe "specifying admin and viewer" do

          subject { User.with_all_roles(:admin, :viewer).sort_by(&:id) }

          it "returns only admins and viewers" do
            subject.must_equal [@admin_author_viewer].sort_by(&:id)
          end

          it "doesn't return non admins or viewers" do
            subject.wont_include @no_role
            subject.wont_include @author_viewer
            subject.wont_include @author_only
            subject.wont_include @admin_only
            subject.wont_include @viewer
          end

        end

        describe "specifying author and viewer" do

          subject { User.with_all_roles(:author, :viewer).sort_by(&:id) }

          it "returns only authors and viewers" do
            subject.must_equal [@admin_author_viewer, @author_viewer].sort_by(&:id)
          end

          it "doesn't return non authors or viewers" do
            subject.wont_include @no_role
            subject.wont_include @admin_only
            subject.wont_include @author_only
            subject.wont_include @viewer
          end

        end

        describe "specifying admin, author and viewer" do

          subject { User.with_all_roles(:admin, :author, :viewer).sort_by(&:id) }

          it "returns only admins, authors and viewers" do
            subject.must_equal [@admin_author_viewer].sort_by(&:id)
          end

          it "doesn't return non admins, authors or viewers" do
            subject.wont_include @no_role
            subject.wont_include @author_viewer
            subject.wont_include @author_only
            subject.wont_include @admin_only
            subject.wont_include @viewer
          end

        end

      end

      describe "with_only_roles" do

        describe "specifying one role" do

          subject { User.with_only_roles(:admin).sort_by(&:id) }

          it "returns users with just that role" do
            subject.must_equal [@admin_only].sort_by(&:id)
          end

          it "doesn't return any other users" do
            subject.wont_include @no_role
            subject.wont_include @admin_author_viewer
            subject.wont_include @author_viewer
            subject.wont_include @author_only
            subject.wont_include @viewer
          end

        end

        describe "specifying multiple roles" do

          subject { User.with_only_roles(:author, :viewer).sort_by(&:id) }

          it "returns only users with no more or less roles" do
            subject.must_equal [@author_viewer].sort_by(&:id)
          end

          it "doesn't return any other users" do
            subject.wont_include @no_role
            subject.wont_include @admin_author_viewer
            subject.wont_include @admin_only
            subject.wont_include @author_only
            subject.wont_include @viewer
          end
        end
      end
    end
  end

end
