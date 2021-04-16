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
    img_url = ''
    if params[:image]
        img = params[:file]
        tempfile = img[:tempfile]
        upload = Cloudinary::Uploader.upload(tempfile.path)
        img_url = upload['url']
    end

    Tip.create(
        user_id: params[:user_id],
        category_id: params[:category_id],
        comment: params[:comment],
        image: img_url
    )
end
