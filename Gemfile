source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.3'

gem 'rails', '~> 6.1.3'
gem 'puma', '~> 5.0'
gem 'sass-rails', '>= 6'
gem 'webpacker', '~> 5.0'
gem 'jbuilder', '~> 2.7'
gem 'bootsnap', '>= 1.4.4', require: false
gem 'chart-js-rails', '~> 0.1.4'
gem 'gon'
gem 'bootstrap', '~> 4.3.1'
gem 'jquery-rails'
gem 'delayed_job_active_record'
gem 'whenever', require: false
gem 'unicorn'
gem 'dotenv-rails'
gem 'slack-notifier'


group :development, :test do
  gem 'sqlite3', '~> 1.4'
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rails-erd'
  gem 'rspec-rails', '~> 4.0.1'

  gem 'capistrano', '~> 3.0.1'
  gem 'capistrano-rails'
  gem 'capistrano-bundler'
end

group :development do
  gem 'web-console', '>= 4.1.0'
  gem 'rack-mini-profiler', '~> 2.0'
  gem 'listen', '~> 3.3'
  gem 'spring'
  gem 'brakeman', :require => false
end

group :test do
  gem 'capybara', '>= 3.26'
  gem 'selenium-webdriver'
  gem 'webdrivers'
end

group :production do
  gem 'mysql2'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
