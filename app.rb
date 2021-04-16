require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
require 'open-uri'
require "sinatra/json"
require './models/models.rb'
require 'sinatra/activerecord'
require 'pry'

get '/' do
    "Hello World!"
end

post '/tips/create/:user_id' do
end
