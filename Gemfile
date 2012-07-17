source 'https://rubygems.org'

# 3.2.6 blow up itslog
gem 'rails', '3.2.3'
gem 'execjs'
gem 'therubyracer'
gem 'jquery-rails'
gem 'haml'
gem 'haml-rails'
gem 'inherited_resources'
gem 'has_scope'
gem 'responders'
gem 'kaminari'
gem 'simple_form'
gem 'devise'
gem 'cancan'

# geo utils
gem 'geokit'
gem 'geokit-rails3'
gem 'gpx2exif', git: 'git://github.com/akwiatkowski/gpx2exif.git'

# png manipulation
gem 'rmagick'

# need some fixes
#gem 'panoramio', git: 'git://github.com/akwiatkowski/ruby-panoramio.git'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platform => :ruby

  gem 'uglifier', '>= 1.0.3'
end


group :development do
  gem 'sqlite3'
  gem 'nifty-generators'
  gem 'heroku'
  gem 'pry-rails'

  # webconsole
  gem 'rack-webconsole-pry', :require => 'rack-webconsole'
end

group :production do
  gem 'pg'
end

group :development, :test do
  gem 'itslog'
  gem 'rspec-rails', '>= 2.6.1.beta1'
end

group :test do
  gem "mocha", :require => false
  gem 'factory_girl' #, ">= 1.1.beta1"
  gem 'capybara', ">= 0.4.1.2"
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
