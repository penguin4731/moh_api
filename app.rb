require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
require 'open-uri'
require "sinatra/json"
require './models/models.rb'
require 'sinatra/activerecord'
require 'json'

before do
    Dotenv.load
    Cloudinary.config do |config|
        config.cloud_name =ENV['CLOUC_NAME']
        config.api_key = ENV['CLOUDINARY_API_KEY']
        config.api_secret = ENV['CLOUDINARY_API_SECRET']
    end
end

get '/' do
end

#全てのtipsを表示させるルーティング
get '/tips/all' do
    tips = Tip.all
    if tips.empty?
        "status:404"
    else
        "status:200"
        tips.to_json
    end
end
error do
    "status:500"
end

#tipsを作るルーティング
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
