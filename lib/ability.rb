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

  attr_reader :user

  def initialize(object=nil)

    # If object has a user attribute set the user from it otherwise assume
    # this is the user.
    @user = object.respond_to?(:user) ? object.user : object

    if @user
      # Add the base user abilities.
      user_class_name = String(@user.class.name)
      append_abilities ability_key(user_class_name) unless user_class_name.empty?
    else
      # If user not set then lets create a guest
      @user = Object.new
      append_abilities :guest
    end

    # If user has roles get those abilities
    if @user.respond_to?(:roles)
      # Add roles on top of the base user abilities
      @user.roles.each { |role| append_abilities(role) }
    end

  end

  private

  def append_abilities(key)
    ability_definitions = Canard.ability_definitions
    instance_eval(&ability_definitions[key]) if ability_definitions.has_key?(key)
  end

  def ability_key(class_name)
    class_name.gsub!('::', '')
    class_name.gsub!(/(.)([A-Z])/,'\1_\2')
    class_name.downcase!.to_sym
  end

end
