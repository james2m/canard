class Ability

  include CanCan::Ability
  
  def ability_definitions
    Canard.ability_definitions
  end

  def initialize(object=nil)
    
    # If a user was passed set the user from it.
    @user = object.is_a?(User) ? object : Object.new
    
    # As guest doesn't respond_to roles it wont get any abilities
    if @user.respond_to?(:roles)
    
      # Add the base user abilities.
      
      # Add roles on top of the base user abilities
      @user.roles.each do |role|
        instance_eval ability_definitions[:role]
      end
      
      can :update, User do |u|
        (@user == u)
      end
    end
  
  end

end