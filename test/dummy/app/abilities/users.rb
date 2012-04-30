Canard::Abilities.for(:user) do
  
  can [:edit, :update], Member, :user_id => user.id
  
  cannot :destroy, User do |u|
    (user == u)
  end
  
end