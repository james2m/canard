require 'cancan'
require 'role_model'
require "canard/version"
require "canard/find_abilities"
require "canard/user_model"
require "ability"

module Canard
end

require 'canard/railtie' if defined?(Rails) && Rails::VERSION::MAJOR >= 3

