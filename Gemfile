ruby '2.6.5'
source "https://rubygems.org"

gem 'sinatra'
gem 'sinatra-contrib'
gem 'rake'
gem 'sinatra-activerecord'
gem 'activerecord', '5.2.8.1'
gem 'rack'
gem 'bcrypt'

gem 'cloudinary'
gem 'dotenv'

group :production do
  gem "activerecord-postgresql-adapter"
  gem 'pg', '~> 0.21.0'
end

group :development do
  gem 'sqlite3', '1.4.1'
  gem 'pry'
end