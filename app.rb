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

#likesを作る
post '/tips/like/:user_id' do
    if firebase_uid_to_uid(params[:user_id])
        user_id = firebase_uid_to_uid(params[:user_id])
        like = Like.find_by(id: params[:id])
        if like.nil?
            Like.create(
                user_id: user_id,
                tips_id: params[:tips_id],
                good: true
            )
            status 200
            json({ ok: true })
        else
            like.update(
                good: !good
            )
        end
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
        questions = add_category(questions)
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
        write_category(params[:question_id], params[:categories])
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

#answerテーブルを作成するルーティング
get '/questions/answer/:question_id' do
    answers = Answer.find_by(question_id: params[:question_id])
    answers.to_json
end


#answerを作るルーティング
post '/questions/answer/create/:user_id' do
    if firebase_uid_to_uid(params[:user_id])
        user_id = firebase_uid_to_uid(params[:user_id])
        img_url = ''
        if params[:image]
            img = params[:file]
            tempfile = img[:tempfile]
            upload = Cloudinary::Uploader.upload(tempfile.path)
            img_url = upload['url']
        end
        Answer.create(
            user_id: user_id,
            comment: params[:comment],
            question_id: params[:question_id],
            image: img_url
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

# カテゴリーを登録
def write_category(question_id, contents)
    if contents == nil
        return
    end
    print(question_id.to_s, contents.to_json)
end



def category_check(question_id, categories_input)
    if categories_input == nil
        return
    end
    categories = categories_input.split(",")
    for category in categories do
        check_data = Category.find_by(name: category)
        if check_data == nil
            # Category.create(
            #     name: category
            # )
        end
        # @category = Category.find_by(name: category)
        # @category.refers.create(post_id: question_id)

        # added_category = Category.find_by(name: category)
        # refers = added_category.refers.create(
        #     post_id: question_id,
        #     category_id: added_category.id
        # )
    end
end

# カテゴリーを出力
def add_category(contents)
    json_format = contents.to_json
    hash_format = JSON.parse json_format
    content_f = []
    for doc in hash_format do
        doc["category"] = create_category_list(doc["question_id"])
        content_f.append(doc)
    end
    return content_f
end

def create_category_list(question_id)
    categories_d = Refer.where(post_id: question_id.to_i)
    category_output = ""
    if categories_d == nil
        return
    end
    for category in categories_d do
        category_output = category_output + ',' + search_category_name(category.category_id)
    end
    return category_output
end

def search_category_name(id)
    category = Category.find(id)
    if category != nil
        return category.name
    else
        return nil
    end
end