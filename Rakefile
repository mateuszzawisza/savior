#!/usr/bin/env rake
begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

require 'rspec/core/rake_task'

desc 'Default: run specs.'
task :default => :spec

desc "Run all specs"
RSpec::Core::RakeTask.new(:spec)

#Bundler::GemHelper.install_tasks
