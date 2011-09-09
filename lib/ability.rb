class Ability

  include CanCan::Ability

  def initialize(object=nil)
    
    # If a user was passed set the user from it.
    @user = object.is_a?(Account) ? object.user : object
    
    # If user not set then lets create a guest
    @user = Object.new unless @user
    # As guest doesn't respond_to roles it wont get any abilities
    if @user.respond_to?(:roles)
    
      # Add the base user abilities.
      load_abilities @user.class.name.to_sym
      
      # Add roles on top of the base user abilities
      @user.roles.each { |role| load_abilities(role) }

    end
  
  end
  
  private
  
  def ability_definitions
    Canard.ability_definitions
  end
  
  def load_abilities(role)
    instance_eval(&ability_definitions[role]) if ability_definitions.has_key?(role)
  end

end
