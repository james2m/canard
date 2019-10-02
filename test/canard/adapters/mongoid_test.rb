# frozen_string_literal: true

require 'test_helper'
require 'bson'

describe Canard::Adapters::Mongoid do
  describe 'acts_as_user' do
    describe 'with a role_mask' do
      describe 'and :roles => [] specified' do
        it 'sets the valid_roles for the class' do
          MongoidUser.valid_roles.must_equal %i[viewer author admin]
        end
      end
    end
  end

  describe 'scopes' do
    describe 'on an Mongoid model with roles' do
      before do
        @no_role             = MongoidUser.create
        @admin_author_viewer = MongoidUser.create(roles: %i[admin author viewer])
        @author_viewer       = MongoidUser.create(roles: %i[author viewer])
        @viewer              = MongoidUser.create(roles: [:viewer])
        @admin_only          = MongoidUser.create(roles: [:admin])
        @author_only         = MongoidUser.create(roles: [:author])
      end

      after do
        MongoidUser.delete_all
      end

      subject { MongoidUser }

      it 'adds a scope to return instances with each role' do
        subject.must_respond_to :admins
        subject.must_respond_to :authors
        subject.must_respond_to :viewers
      end

      it 'adds a scope to return instances without each role' do
        subject.must_respond_to :non_admins
        subject.must_respond_to :non_authors
        subject.must_respond_to :non_viewers
      end

      describe 'finding instances with a role' do
        describe 'admins scope' do
          subject { MongoidUser.admins.sort_by(&:id) }

          it 'returns only admins' do
            subject.must_equal [@admin_author_viewer, @admin_only].sort_by(&:id)
          end

          it "doesn't return non admins" do
            subject.wont_include @no_role
            subject.wont_include @author_viewer
            subject.wont_include @author_only
            subject.wont_include @viewer
          end
        end

        describe 'authors scope' do
          subject { MongoidUser.authors.sort_by(&:id) }

          it 'returns only authors' do
            subject.must_equal [@admin_author_viewer, @author_viewer, @author_only].sort_by(&:id)
          end

          it "doesn't return non authors" do
            subject.wont_include @no_role
            subject.wont_include @admin_only
            subject.wont_include @viewer
          end
        end

        describe 'viewers scope' do
          subject { MongoidUser.viewers.sort_by(&:id) }

          it 'returns only viewers' do
            subject.must_equal [@admin_author_viewer, @author_viewer, @viewer].sort_by(&:id)
          end

          it "doesn't return non authors" do
            subject.wont_include @no_role
            subject.wont_include @admin_only
            subject.wont_include @author_only
          end
        end
      end

      describe 'finding instances without a role' do
        describe 'non_admins scope' do
          subject { MongoidUser.non_admins.sort_by(&:id) }

          it 'returns only non_admins' do
            subject.must_equal [@no_role, @author_viewer, @viewer, @author_only].sort_by(&:id)
          end

          it "doesn't return admins" do
            subject.wont_include @admin_author_viewer
            subject.wont_include @admin_only
          end
        end

        describe 'non_authors scope' do
          subject { MongoidUser.non_authors.sort_by(&:id) }

          it 'returns only non_authors' do
            subject.must_equal [@no_role, @viewer, @admin_only].sort_by(&:id)
          end

          it "doesn't return authors" do
            subject.wont_include @admin_author_viewer
            subject.wont_include @author_viewer
            subject.wont_include @author_only
          end
        end

        describe 'non_viewers scope' do
          subject { MongoidUser.non_viewers.sort_by(&:id) }

          it 'returns only non_viewers' do
            subject.must_equal [@no_role, @admin_only, @author_only].sort_by(&:id)
          end

          it "doesn't return viewers" do
            subject.wont_include @admin_author_viewer
            subject.wont_include @author_viewer
            subject.wont_include @viewer
          end
        end
      end

      describe 'with_any_role' do
        describe 'specifying admin only' do
          subject { MongoidUser.with_any_role(:admin).sort_by(&:id) }

          it 'returns only admins' do
            subject.must_equal [@admin_author_viewer, @admin_only].sort_by(&:id)
          end

          it "doesn't return non admins" do
            subject.wont_include @no_role
            subject.wont_include @author_viewer
            subject.wont_include @author_only
            subject.wont_include @viewer
          end
        end

        describe 'specifying author only' do
          subject { MongoidUser.with_any_role(:author).sort_by(&:id) }

          it 'returns only authors' do
            subject.must_equal [@admin_author_viewer, @author_viewer, @author_only].sort_by(&:id)
          end

          it "doesn't return non authors" do
            subject.wont_include @no_role
            subject.wont_include @admin_only
            subject.wont_include @viewer
          end
        end

        describe 'specifying viewer only' do
          subject { MongoidUser.with_any_role(:viewer).sort_by(&:id) }

          it 'returns only viewers' do
            subject.must_equal [@admin_author_viewer, @author_viewer, @viewer].sort_by(&:id)
          end

          it "doesn't return non authors" do
            subject.wont_include @no_role
            subject.wont_include @admin_only
            subject.wont_include @author_only
          end
        end

        describe 'specifying admin and author' do
          subject { MongoidUser.with_any_role(:admin, :author).sort_by(&:id) }

          it 'returns only admins and authors' do
            subject.must_equal [@admin_author_viewer, @author_viewer, @admin_only, @author_only].sort_by(&:id)
          end

          it "doesn't return non admins or authors" do
            subject.wont_include @no_role
            subject.wont_include @viewer
          end
        end

        describe 'specifying admin and viewer' do
          subject { MongoidUser.with_any_role(:admin, :viewer).sort_by(&:id) }

          it 'returns only admins and viewers' do
            subject.must_equal [@admin_author_viewer, @author_viewer, @admin_only, @viewer].sort_by(&:id)
          end

          it "doesn't return non admins or viewers" do
            subject.wont_include @no_role
            subject.wont_include @author_only
          end
        end

        describe 'specifying author and viewer' do
          subject { MongoidUser.with_any_role(:author, :viewer).sort_by(&:id) }

          it 'returns only authors and viewers' do
            subject.must_equal [@admin_author_viewer, @author_viewer, @author_only, @viewer].sort_by(&:id)
          end

          it "doesn't return non authors or viewers" do
            subject.wont_include @no_role
            subject.wont_include @admin_only
          end
        end

        describe 'specifying admin, author and viewer' do
          subject { MongoidUser.with_any_role(:admin, :author, :viewer).sort_by(&:id) }

          it 'returns only admins, authors and viewers' do
            subject.must_equal [@admin_author_viewer, @author_viewer, @admin_only, @author_only, @viewer].sort_by(&:id)
          end

          it "doesn't return non admins, authors or viewers" do
            subject.wont_include @no_role
          end
        end
      end

      describe 'with_all_roles' do
        describe 'specifying admin only' do
          subject { MongoidUser.with_all_roles(:admin).sort_by(&:id) }

          it 'returns only admins' do
            subject.must_equal [@admin_author_viewer, @admin_only].sort_by(&:id)
          end

          it "doesn't return non admins" do
            subject.wont_include @no_role
            subject.wont_include @author_viewer
            subject.wont_include @author_only
            subject.wont_include @viewer
          end
        end

        describe 'specifying author only' do
          subject { MongoidUser.with_all_roles(:author).sort_by(&:id) }

          it 'returns only authors' do
            subject.must_equal [@admin_author_viewer, @author_viewer, @author_only].sort_by(&:id)
          end

          it "doesn't return non authors" do
            subject.wont_include @no_role
            subject.wont_include @admin_only
            subject.wont_include @viewer
          end
        end

        describe 'specifying viewer only' do
          subject { MongoidUser.with_all_roles(:viewer).sort_by(&:id) }

          it 'returns only viewers' do
            subject.must_equal [@admin_author_viewer, @author_viewer, @viewer].sort_by(&:id)
          end

          it "doesn't return non authors" do
            subject.wont_include @no_role
            subject.wont_include @admin_only
            subject.wont_include @author_only
          end
        end

        describe 'specifying admin and author' do
          subject { MongoidUser.with_all_roles(:admin, :author).sort_by(&:id) }

          it 'returns only admins and authors' do
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

        describe 'specifying admin and viewer' do
          subject { MongoidUser.with_all_roles(:admin, :viewer).sort_by(&:id) }

          it 'returns only admins and viewers' do
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

        describe 'specifying author and viewer' do
          subject { MongoidUser.with_all_roles(:author, :viewer).sort_by(&:id) }

          it 'returns only authors and viewers' do
            subject.must_equal [@admin_author_viewer, @author_viewer].sort_by(&:id)
          end

          it "doesn't return non authors or viewers" do
            subject.wont_include @no_role
            subject.wont_include @admin_only
            subject.wont_include @author_only
            subject.wont_include @viewer
          end
        end

        describe 'specifying admin, author and viewer' do
          subject { MongoidUser.with_all_roles(:admin, :author, :viewer).sort_by(&:id) }

          it 'returns only admins, authors and viewers' do
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

      describe 'with_only_roles' do
        describe 'specifying one role' do
          subject { MongoidUser.with_only_roles(:admin).sort_by(&:id) }

          it 'returns users with just that role' do
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

        describe 'specifying multiple roles' do
          subject { MongoidUser.with_only_roles(:author, :viewer).sort_by(&:id) }

          it 'returns only users with no more or less roles' do
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
