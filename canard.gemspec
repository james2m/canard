# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require 'canard/version'

Gem::Specification.new do |s|
  s.name        = 'canard'
  s.version     = Canard::VERSION
  s.date        = `git log -1 --format="%cd" --date=short lib/canard/version.rb`
  s.authors     = ['James McCarthy']
  s.email       = ['james2mccarthy@gmail.com']
  s.homepage    = 'https://github.com/james2m/canard'
  s.summary     = %q{Adds role based authorisation to Rails by combining RoleModel and CanCanCan.}
  s.description = %q{Wraps CanCanCan and RoleModel up to make role based authorisation really easy in Rails 4+.}

  s.rubyforge_project = "canard"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_development_dependency 'minitest', '~> 2'
  s.add_development_dependency 'rails', '~> 3.2.3', '>= 3.2.3'
  s.add_development_dependency 'mongoid', '~> 3.0'

  s.requirements << "cancan's community supported Rails4+ compatible cancancan fork."
  s.add_runtime_dependency 'cancancan', '>= 1'
  s.add_runtime_dependency 'role_model', '~> 0'
end
