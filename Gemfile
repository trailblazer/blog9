source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# ruby '2.6.5'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.3', '>= 6.0.3.2'
# Use sqlite3 as the database for Active Record
gem 'sqlite3', '~> 1.4'
# Use Puma as the app server
gem 'puma', '~> 4.1'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 4.0'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

gem "trailblazer", ">= 2.1.0"
# gem "trailblazer-developer", path: "../trailblazer-developer"
# gem "trailblazer-developer"
gem "trailblazer-workflow", path: "../trailblazer-workflow"
# gem "trailblazer-activity", path: "../trailblazer-activity"
gem "trailblazer-activity-implementation", path: "../trailblazer-activity-implementation"
gem "trailblazer-endpoint", path: "../trailblazer-endpoint"
# gem "trailblazer-endpoint", "0.0.8"
# gem "trailblazer-context", path: "../trailblazer-context"
gem "reform-rails", "0.2.1"
gem "reform", "2.3.3" # we can also use older reforms! # FIXME: remove!
gem "trailblazer-cells"
gem "cells-erb"
gem "cells-rails"
gem "simple_form"
gem "rails_email_validator"

# gem "trailblazer-operation", path: "../trailblazer-operation"
# gem "trailblazer-activity-dsl-linear", path: "../trailblazer-activity-dsl-linear"
# gem "trailblazer-activity", path: "../trailblazer-activity"

# gem "trailblazer-activity",       github: "trailblazer/trailblazer-activity", branch: "ruby-3"
# gem "trailblazer-activity-dsl-linear", github: "trailblazer/trailblazer-activity-dsl-linear", branch: "ruby-3"
# gem "trailblazer-operation",      github: "trailblazer/trailblazer-operation", branch: "ruby-3"
# gem "trailblazer-operation",      path: "../trailblazer-operation"
# gem "trailblazer-macro",          github: "trailblazer/trailblazer-macro", branch: "ruby-3"
# gem "trailblazer-macro-contract", github: "trailblazer/trailblazer-macro-contract", branch: "ruby-3"
gem "trailblazer-operation", ">= 0.7.1"
gem "bcrypt"

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  # gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]

  # gem "minitest-spec-rails"
  # gem "minitest-rails"
  # gem "minitest-rails-capybara", "3.0.2"
end

group :development do
# gem "trailblazer-generator", path: "../trailblazer-generator"
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem "faraday"
  gem "multi_json"

  # gem "database_cleaner-active_record"
end

group :test do
  gem "rexml"
  gem "minitest"
  gem "minitest-line"
  # gem "trailblazer-test"
  gem "trailblazer-test", path: "../trailblazer-test"

  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
