#!/usr/bin/env rake

# chefspec task against spec/*_spec.rb
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:chefspec)

# foodcritic rake task
desc 'Foodcritic linter'
task :foodcritic do
  sh 'foodcritic -f correctness .'
end

# rubocop rake task
desc 'Ruby style guide linter'
task :rubocop do
  sh 'rubocop --fail-level E'
end

# Deploy task
desc 'Deploy to chef server and pin to environment'
task :deploy do
  sh 'berks upload'
  sh 'berks apply ci'
end

# share cookbook to Chef community site
desc 'Share cookbook to community site'
task :share do
  sh 'knife cookbook site share krb5 other'
end

# default tasks are quick, commit tests
task :default => %w(foodcritic rubocop chefspec)

# jenkins tasks format for metric tracking
task :jenkins => %w(foodcritic rubocop chefspec)
