require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
require 'open-uri'
require "sinatra/json"
require './models/models.rb'
require 'sinatra/activerecord'
require "json"

before do
    Dotenv.load
    Cloudinary.config do |config|
        config.cloud_name =ENV['CLOUC_NAME']
        config.api_key = ENV['CLOUDINARY_API_KEY']
        config.api_secret = ENV['CLOUDINARY_API_SECRET']
    end
end

not_found do
    status 404
end

error do
    status 500
end

#全てのtipsを返すルーティング
get '/tips/all' do
    tips = Tip.all
    if tips.empty?
        status 204
    else
        tips = add_user_name(tips)
        tips.to_json
    end
end

# 自分が投稿したTipsを返すルーティング
get '/tips/:user_id' do
    if firebase_uid_to_uid(params[:user_id])
        user_id = firebase_uid_to_uid(params[:user_id])
        tips = Tips.where(user_id: user_id)
        tips = add_user_name(tips)
        tips.to_json
    else
        status 400
        json({ ok: false })
    end
end

#tipsを作るルーティング
post '/tips/create/:user_id' do
    if firebase_uid_to_uid(params[:user_id])
        user_id = firebase_uid_to_uid(params[:user_id])
        print(user_id, params[:comment], params[:title])
        Tip.create(
            user_id: user_id,
            comment: params[:comment],
            title: params[:title]
        )
        status 200
        json({ ok: true })
    else
        status 400
        json({ ok: false })
    end
end

#tips_repliesを返すルーティング 削除予定
get '/tips/replies/:tips_id' do
    replies = Tip_reply.find_by(tip_id: params[:tips_id])
    if replies.empty?
        status 204
    else
        replies.to_json
    end
end

#repliesを作るルーティング 削除予定
post '/tips/reply/create/:user_id' do
    if firebase_uid_to_uid(params[:user_id])
        user_id = firebase_uid_to_uid(params[:user_id])
        img_url = ''
        if params[:image]
            img = params[:file]
            tempfile = img[:tempfile]
            upload = Cloudinary::Uploader.upload(tempfile.path)
            img_url = upload['url']
        end
        Tip_reply.create(
            user_id: user_id,
            tip_id: params[:tip_id],
            comment: params[:comment],
            image: img_url
        )
        status 200
        json({ ok: true })
    else
        status 400
        json({ ok: false })
    end
end

#questionsを全て返す
get '/questions/all' do
    questions = Question.all
    if questions.empty?
        status 204
    else
        questions = add_user_name(questions)
        questions.to_json
    end
end

# 自分が質問したquestionsを全て返す
get '/questions/:user_id' do
    if firebase_uid_to_uid(params[:user_id])
        user_id = firebase_uid_to_uid(params[:user_id])
        questions = Question.where(user_id: user_id)
        questions = add_user_name(questions)
        questions.to_json
    else
        status 400
        json({ ok: false })
    end
end

#questionsを作るルーティング
post '/questions/create/:user_id' do
    if firebase_uid_to_uid(params[:user_id])
        user_id = firebase_uid_to_uid(params[:user_id])
        img_url = ''
        if params[:image]
            img = params[:file]
            tempfile = img[:tempfile]
            upload = Cloudinary::Uploader.upload(tempfile.path)
            img_url = upload['url']
        end
        Question.create(
            user_id: user_id,
            comment: params[:comment],
            title: params[:title],
            image: img_url,
            bestanswer_id: 0
        )
        status 200
        json({ ok: true })
    else
        status 400
        json({ ok: false })
    end
end

#usersを作るルーティング
post '/user/create' do
    user = User.find_by(firebase_uid: params[:firebase_uid])
    if user != nil
        user.update(
            firebase_uid: params[:firebase_uid],
            name: params[:name]
        )
    else
        User.create(
            firebase_uid: params[:firebase_uid],
            name: params[:name]
        )
    end
    status 200
    json({ ok: true })
end

# テスト用
get '/test/:content' do
    status 200
    json({ ok: true, content: params[:content] })
end

post '/test' do
    status
    json({ ok: true, params: params })
end

# firebaseのUIDからuserIDを探す
def firebase_uid_to_uid(firebase_uid)
    user = User.find_by(firebase_uid: firebase_uid)
    if user != nil
        return user.id
    else
        return nil
    end
end

# get user name
def add_user_name(contents)
    json_f = contents.to_json
    hash_f = JSON.parse json_f
    content_f = []
    for doc in hash_f do
        doc["user_name"] = user_name(doc['user_id'])
        content_f.append(doc)
    end
    return content_f
end

def user_name(id)
    user = User.find(id)
    if user != nil
        return user.name
    else
        return nil
    end
end