source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.2'

# Authentication
gem 'devise'
gem 'devise_invitable', '~> 2.0.0'
gem 'simple_token_authentication', '~> 1.0'

# JS bundling
gem 'vite_rails'
gem 'vite_ruby'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem 'rails', '~> 7.0.4'

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem 'sprockets-rails'

# Use postgresql as the database for Active Record
gem 'pg', '~> 1.1'

# Use the Puma web server [https://github.com/puma/puma]
gem 'puma', '~> 5.0'

# # Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem 'turbo-rails'

# # Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem 'stimulus-rails'

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem 'jbuilder'

# Gem to send emails straight from contact form
gem 'mail_form'

# Let's you write Ruby Cron Tasks in ruby code
gem 'whenever', require: false

# Search
gem 'pg_search'

# Geocoder for address search when sign up
gem 'geocoder'

# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem 'kredis'

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem 'bcrypt', '~> 3.1.7'

# Integration of money gem - used for handling prices in DB
gem 'money-rails', '~>1.12'

# Payments
gem 'stripe'
gem 'stripe_event'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[ mingw mswin x64_mingw jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

# Use Sass to process CSS
gem 'sassc-rails'

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem 'image_processing', '~> 1.2'

gem 'autoprefixer-rails'
gem 'font-awesome-sass', '~> 6.1'
gem 'simple_form', github: 'heartcombo/simple_form'

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug', platforms: %i[ mri mingw x64_mingw ]
  gem 'dotenv-rails'
  gem 'rspec-rails', '~> 6.0.0'
  gem 'faker', :git => 'https://github.com/faker-ruby/faker.git', :branch => 'main'
  gem 'factory_bot_rails'
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem 'web-console'

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem 'rack-mini-profiler'

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem 'spring'
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'webdrivers'
end


gem "noticed", "~> 1.6"
