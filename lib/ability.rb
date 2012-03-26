class Ability

  include CanCan::Ability

  def initialize(object=nil)
    
    # If a user was passed set the user from it.
    @user = object.is_a?(Account) ? object.user : object
    
    if @user
      # Add the base user abilities.
      append_abilities @user.class.name.underscore.to_sym
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
  
  def user
    @user
  end
  
  def ability_definitions
    Canard::Abilities.definitions
  end
  
  def append_abilities(role)
    instance_eval(&ability_definitions[role]) if ability_definitions.has_key?(role)
  end

end
