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

error do
    status 500
end

#全てのtipsを返すルーティング
get '/tips/all' do
    tips = Tip.all
    if tips.empty?
        status 404
    else
        tips.to_json
    end
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
        refer_id: params[:category_id],
        comment: params[:comment],
        image: img_url
    )
end

#tips_repliesを返すルーティング
get '/tips/replies/:tips_id' do
    replies = Tip_reply.find_by(tip_id: params[:tips_id])
    if replies.empty?
        status 404
    else
        replies.to_json
    end
end

#repliesを作るルーティング
post '/tips/reply/create/:user_id' do
    img_url = ''
    if params[:image]
        img = params[:file]
        tempfile = img[:tempfile]
        upload = Cloudinary::Uploader.upload(tempfile.path)
        img_url = upload['url']
    end
    Tip_reply.create(
        user_id: params[:user_id],
        tip_id: params[:tip_id],
        comment: params[:comment],
        image: img_url
    )
end

#questionsを返すルーティング
get '/questions/:user_id' do
    questions = Question.all
    if questions.empty?
        status 404
    else
        questions.to_json
    end
end

#questionsを作るルーティング
post '/questions/create/:user_id' do
    img_url = ''
    if params[:image]
        img = params[:file]
        tempfile = img[:tempfile]
        upload = Cloudinary::Uploader.upload(tempfile.path)
        img_url = upload['url']
    end
    Question.create(
        user_id: params[:user_id],
        refer_id: params[:refer_id],
        comment: params[:comment],
        image: img_url,
        bestanswer_id: 0
    )
end