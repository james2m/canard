# frozen_string_literal: true

Canard::Abilities.for(:guest) do
  can :read, Post
end
