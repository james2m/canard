# frozen_string_literal: true

Canard::Abilities.for(:user) do
  can %i[edit update], Member, user_id: user.id
end
