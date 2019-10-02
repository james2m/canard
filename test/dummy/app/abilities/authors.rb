# frozen_string_literal: true

Canard::Abilities.for(:author) do
  can %i[create update read], Post
end
