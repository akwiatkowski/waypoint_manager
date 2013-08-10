source 'https://rubygems.org'
#ruby "2.0.0"

gem 'rails'
gem 'thin'
gem 'execjs'
gem 'jquery-rails'
gem 'haml'
gem 'haml-rails'
gem 'inherited_resources'
gem 'has_scope'
gem 'responders'
gem 'kaminari'
gem 'sorted'
gem 'simple_form'
gem 'devise'
gem 'cancan'
gem 'high_voltage'
gem 'navigasmic'
gem 'simple_show_helper'
gem 'jquery-rails'
gem 'configatron'

# bootstrap stuff
#gem 'libv8' #, '~> 3.11.8'
gem "therubyracer", :require => 'v8', :platforms => :ruby
gem "less-rails" #Sprockets (what Rails 3.1 uses for its asset pipeline) supports LESS
gem "twitter-bootstrap-rails"

# geo utils
gem 'geokit'
gem 'geokit-rails3'
gem 'openlayers-rails'
gem 'gpx2exif' #, git: 'git://github.com/akwiatkowski/gpx2exif.git'
gem 'RubySunrise', require: 'solareventcalculator'

# png manipulation
gem 'rmagick'

# need some fixes
#gem 'panoramio', git: 'git://github.com/akwiatkowski/ruby-panoramio.git'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails'
  gem 'coffee-rails'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platform => :ruby

  gem 'uglifier'
end


group :development do
  gem 'sqlite3'
  gem 'nifty-generators'
  gem 'heroku'
  gem 'taps'
  gem 'pry-rails'

  # webconsole
  gem 'rack-webconsole-pry', :require => 'rack-webconsole'
end

group :production do
  gem 'pg'
end

group :development, :test do
  #gem 'itslog', git: "https://github.com/elle/itslog"
  gem 'rspec-rails', '>= 2.6.1.beta1'
  gem 'rails_best_practices'
end

group :test do
  gem "mocha", :require => false
  gem 'factory_girl' #, ">= 1.1.beta1"
  gem 'capybara', "2.0.3"
  gem 'database_cleaner', '>= 0.6.7'
  gem 'spork'
end


# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'
