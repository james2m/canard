# frozen_string_literal: true

Canard::Abilities.for(:administrator) do
  can :manage, [Activity, User]
end
