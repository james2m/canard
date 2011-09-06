abilities_for(:admin) do
    
  can :manage, [Activity, User, Variation, Year]
  
  cannot :destroy, User do |u|
    (user == u)
  end
    
end
