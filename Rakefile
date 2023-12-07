# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rake'
require 'rake/testtask'

Rake::TestTask.new(:test) do |t|
  t.libs << 'lib' << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
  t.warning = false
end

task default: ['test']
