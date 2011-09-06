# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "canard/version"

Gem::Specification.new do |s|
  s.name        = "canard"
  s.version     = Canard::VERSION
  s.authors     = ["James McCarthy"]
  s.email       = ["james2mccarthy@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Adds RoleModel roles to CanCan.}
  s.description = %q{Wraps CanCan and RoleModel up with some scopes}

  s.rubyforge_project = "canard"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "minitest", "~> 2"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "activerecord"
  s.add_runtime_dependency "cancan"
  s.add_runtime_dependency "role_model"
end
