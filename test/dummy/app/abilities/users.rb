Canard::Abilities.for(:user) do
  
  can [:edit, :update], Member, :user_id => user.id
  
end