source 'https://rubygems.org'

gem 'berkshelf', '~> 3.1'
gem 'chefspec', '~> 4.0'
gem 'rspec', '~> 3.0'
gem 'chef-zero', '~> 2.0'
gem 'foodcritic', '~> 3.0'

gem 'ridley', '~> 4.2.0'
gem 'faraday', '< 0.9.2'

gem 'rack', '< 2.0' if RUBY_VERSION.to_f < 2.2

if RUBY_VERSION.to_f < 2.1
  gem 'buff-ignore', '< 1.2'
  gem 'fauxhai', '< 3.5'
  gem 'dep_selector', '< 1.0.4'
end

if RUBY_VERSION.to_f < 2.0
  gem 'chef', '< 12.0'
  gem 'json', '< 2.0'
  gem 'varia_model', '< 0.5.0'
  gem 'rubocop', '< 0.42'
end

group :integration do
  gem 'test-kitchen'
  gem 'kitchen-vagrant'
end
