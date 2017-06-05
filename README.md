Canard
======
[![Build Status](https://travis-ci.org/james2m/canard.svg?branch=master)](https://travis-ci.org/james2m/canard)

Canard brings CanCan and RoleModel together to make role-based authorization in Rails easy. Your ability
definitions gain their own folder and a little structure. The easiest way to get started is with the
Canard generator. Canard progressively enhances the abilities of the model by applying role abilities on
top of the model's base abilities.
A User model with :admin and :manager roles would be defined:

    class User < ActiveRecord::Base

      acts_as_user :roles => [ :manager, :admin ]

    end

If a User has both the :manager and :admin roles, Canard looks first for user abilities. Then it will look for other roles in the order that they are defined:

    app/abilities/users.rb
    app/abilities/manager.rb
    app/abilities/admin.rb

Therefore each of the later abilities can build on its predecessor.

Usage
=====
To generate some abilities for the User:

    $ rails g canard:ability user can:[read,create]:[account,statement] cannot:destroy:account
    create  app/abilities/users.rb
    invoke  rspec
    create    spec/abilities/user_spec.rb

This action generates an ability folder in Rails root and an associated spec:

    app.abilities/
      users.rb
    spec/abilities/
      users_spec.rb

The resulting app/abilities/users.rb will look something like this:

    Canard::Abilities.for(:user) do

      can     [:read, :create], Account
      cannot  [:destroy], Account
      can     [:read, :create], Statement

    end

And its associated test spec/abilities/users_spec.rb will look something like this:

    require_relative '../spec_helper'
    require "cancan/matchers"

    describe Ability, "for :user" do

      before do
        @user = Factory.create(:user_user)
      end

      subject { Ability.new(@user) }

      describe 'on Account' do

        before do
          @account = Factory.create(:account)
        end

        it { should be_able_to( :read,      @account ) }
        it { should be_able_to( :create,    @account ) }
        it { should_not be_able_to( :destroy,   @account ) }

      end
      # on Account

      describe 'on Statement' do

        before do
          @statement = Factory.create(:statement)
        end

        it { should be_able_to( :read,      @statement ) }
        it { should be_able_to( :create,    @statement ) }

      end
      # on Statement

    end

You can also re-use abilities defined for one role in another. This allows you to 'inherit' abilities without having to assign all of the roles to the user. To do this, pass a list of role names to the includes_abilities_of method:

    Canard::Abilities.for(:writer) do

      can     [:create], Post
      can     [:read], Post, user_id: user.id

    end

    Canard::Abilities.for(:reviewer) do

      can     [:read, :update], Post

    end

    Canard::Abilities.for(:admin) do

      includes_abilities_of :writer, :reviewer

      can     [:delete], Post

    end

A user assigned the :admin role will have all of the abilities of the :writer and :reviewer, along with their own abilities, without having to have those individual roles assigned to them.

Now let's generate some abilities for the manager and admin:

    $ rails g canard:ability admin can:manage:[account,statement]
    $ rails g canard:ability manager can:edit:statement

This generates two new sets of abilities in the abilities folder. Canard will apply these abilities by first
loading the ability for the User model and then applying the abilities for each of the current user's roles.


If there is no user (i.e. logged out), Canard creates a guest and looks for a guest ability to apply:

    $ rails g canard:ability guest can:create:user

This would generate a signup ability for a user who was not logged in.

Obviously the generators are just a starting point and should be used only to get you going. I strongly
suggest that you add each new model to the abilities because the specs are easy to write and CanCan
definitions are very clear and simple.

Scopes
======
The :acts_as_user method will automatically define some named scopes for each role. For the User model
above it will define the following scopes:

`User.admins::`       return all the users with the admin role   
`User.non_admins::`   return all the users without the admin role   
`User.managers::`     return all the users with the manager role   
`User.non_managers::` return all the users without the manager role   

In addition to the role specific scopes it also adds some general scopes:

`User.with_any_role(roles)::`   return all the users with any of the specified roles   
`User.with_all_roles(roles)::`  return only the users with all the specified roles   

Installation
============

Rails 3.x, 4.x & 5.x
--------------------
Add the canard gem to your Gemfile:

    gem "canard"

Add the `roles_mask` field to your user table:

    rails g migration add_roles_mask_to_users roles_mask:integer
    rake db:migrate

That's it!

Rails 2.x
---------

Sorry, you are out of luck. Canard has only been written and tested with Rails 3 and above.

Supported ORMs
---------------

Canard is ORM agnostic. ActiveRecord and Mongoid (thanks David Butler) adapters are currently implemented.
New adapters can easily be added, but you'd need to check to see if CanCan can also support your adapter.

Further reading
---------------

Canard stands on the shoulders of Ryan Bates' CanCan and Martin Rehfeld's RoleModel. You can read more
about defining abilities on the CanCan wiki (https://github.com/ryanb/cancan/wiki). Canard implements
the Ability class for you so you don't need the boilerplate code from Ryan's example:

    class Ability
      include CanCan::Ability

      def initialize(user)
        user ||= User.new # guest user (not logged in)
        if user.admin?
          can :manage, :all
        else
          can :read, :all
        end
      end
    end

The Canard equivalent for non-admins would be:

    Canard::Abilities.for(:user) do
      can :read, :all
    end

And for admins:

    Canard::Abilities.for(:admin) do
      can :manage, :all
    end

Under the covers Canard uses RoleModel (https://github.com/martinrehfeld/role_model) to define roles. RoleModel
is based on Ryan Bates' suggested approach to role based authorization which is documented in the CanCan
wiki (https://github.com/ryanb/cancan/wiki/role-based-authorization).

Note on Patches/Pull Request
----------------------------

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it (when I have some). This is important so I don't break it in a future version unintentionally.
* Commit. Do not mess with rakefile, version, or history. (If you want to have your own version, that is fine but
  bump version in a commit by itself so I can ignore it when I pull.)
* Send me a pull request.  Bonus points for topic branches.

Contributors
------------

    git log | grep Author | sort | uniq

* Alessandro Dal Grande
* David Butler
* Dmitriy Molodtsov
* Dmytro Salko
* James McCarthy
* Jesse McGinnis
* Joey Geiger
* Jon Kinney
* Justin Buchanan
* Morton Jonuschat
* Piotr Kuczynski
* Thomas Hoen
* Travis Berry

If you feel like contributing there is a TODO list in the root with a few ideas and opportunities!

Credits
-------

Thanks to Ryan Bates for creating the awesome CanCan (http://wiki.github.com/ryanb/cancan)
and Martin Rehfeld for implementing Role Based Authorization in the form of RoleModel (http://github.com/martinrehfeld/role_model).

Copyright
---------
Copyright (c) 2011-2017 James McCarthy, released under the MIT license
