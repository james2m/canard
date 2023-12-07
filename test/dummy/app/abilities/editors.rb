# frozen_string_literal: true

Canard::Abilities.for(:editor) do
  includes_abilities_of :author

  cannot :create, Post
end
