# frozen_string_literal: true

# Canard provides a CanCan Ability class for you. The Canard Ability class
# looks for and applies abilities for the object passed when a new Ability
# instance is initialized.
#
# If the passed object has a reference to user the user is set to that.
# Otherwise the passed object is assumed to be the user. This gives the
# flexibility to have a seperate model for authorization from the model used
# to authenticate the user.
#
# Abilities are applied in the order they are set with the acts_as_user method
# for example for the User model
#
#     class User < ActiveRecord::Base
#
#       acts_as_user :roles =>  :manager, :admin
#
#     end
#
# the abilities would be applied in the order: users, managers, admins
# with each subsequent set of abilities building on or overriding the existing
# abilities.
#
# If there is no object passed to the Ability.new method a guest ability is
# created and Canard will look for a guests.rb amongst the ability definitions
# and give the guest those abilities.
class Ability
  include CanCan::Ability
  extend Forwardable

  attr_reader :user

  def_delegators :Canard, :ability_definitions, :ability_key

  def initialize(object = nil)
    # If object has a user attribute set the user from it otherwise assume
    # this is the user.
    @user = object.respond_to?(:user) ? object.user : object

    add_base_abilities
    add_roles_abilities if @user.respond_to?(:roles)
  end

  protected

  def add_base_abilities
    if @user
      # Add the base user abilities.
      user_class_name = String(@user.class.name)
      append_abilities user_class_name unless user_class_name.empty?
    else
      # If user not set then lets create a guest
      @user = Object.new
      append_abilities :guest
    end
  end

  def add_roles_abilities
    @user.roles.each { |role| append_abilities(role) }
  end

  def append_abilities(dirty_key)
    key = ability_key(dirty_key)
    instance_eval(&ability_definitions[key]) if ability_definitions.key?(key)
  end

  def includes_abilities_of(*other_roles)
    other_roles.each { |other_role| append_abilities(other_role) }
  end
end
