Canard::Abilities.for(:administrator) do

  can :manage, [Activity, User]

end
