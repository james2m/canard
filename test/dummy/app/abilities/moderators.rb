Canard::Abilities.for(:moderator) do
    
  can :manage, [Post]
  
  cannot :destroy, User do |u|
    (user == u)
  end
    
end
