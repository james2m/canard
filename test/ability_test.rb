require 'test_helper'

describe Ability do
  
  before do
    # reload abilities because the reloader will have removed them after the railtie ran
    Canard.find_abilities
  end
    
  describe "new" do
    
    describe "with a user" do
      
      let(:user) { User.new }
      subject { Ability.new(user) }
      
      it "assign the user to Ability#user" do
        subject.user.must_equal user
      end

    end
    
    describe "with a model that references a user" do
      
      let(:user) { User.create }
      let(:member) { Member.new(user: user) }
      
      subject { Ability.new(member) }
      
      it "assign the user to Ability#user" do
        subject.user.must_equal user
      end

    end
    
    describe "for a user with author role" do
      
      let(:user) { User.create(:roles => [:author]) }
      let(:member) { Member.create(user: user) }
      let(:other_member) { Member.new(user: User.create) }
      subject { Ability.new(user) }
      
      it "has all the abilities of the base class" do
        subject.can?(:edit, member).must_equal true
        subject.can?(:update, member).must_equal true

        subject.can?(:edit, other_member).wont_equal true
        subject.can?(:update, other_member).wont_equal true
      end
      
      it "has all the abilities of an author" do
        subject.can?(:new, Post).must_equal true
        subject.can?(:create, Post).must_equal true
        subject.can?(:edit, Post).must_equal true
        subject.can?(:update, Post).must_equal true
        subject.can?(:show, Post).must_equal true
        subject.can?(:index, Post).must_equal true
      end
      
      it "has no admin abilities" do
        subject.cannot?(:destroy, Post).must_equal true
      end
      
    end

    describe "for a user with admin and author role" do
      
      let(:user) { User.create(:roles => [:author, :admin]) }
      let(:member) { Member.create(user: user) }
      let(:other_user) { User.create }
      let(:other_member) { Member.new(user: other_user) }
      subject { Ability.new(user) }
      
      it "has all the abilities of the base class" do
        subject.can?(:edit, member).must_equal true
        subject.can?(:update, member).must_equal true

        subject.cannot?(:edit, other_member).must_equal true
        subject.cannot?(:update, other_member).must_equal true
      end
      
      it "has all the abilities of an author" do
        subject.can?(:new, Post).must_equal true
      end
      
      it "has the abilities of an admin" do
        subject.can?(:manage, Post).must_equal true
        subject.can?(:manage, other_user).must_equal true
        subject.can?(:destroy, other_user).must_equal true
        subject.cannot?(:destroy, user).must_equal true
      end
      
    end
    
    describe "for a guest" do
      
      subject { Ability.new }
      
      it "applies the guest abilities" do
        subject.can?(:index, Post)
        subject.can?(:show, Post)
        
        subject.cannot?(:create, Post)
        subject.cannot?(:update, Post)
        subject.cannot?(:destroy, Post)
        
        subject.cannot?(:show, User)
        subject.cannot?(:show, Member)
      end
    end
  end
  
end
