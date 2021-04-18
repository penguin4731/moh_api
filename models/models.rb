require 'bundler/setup'
Bundler.require

if development?
    ActiveRecord::Base.establish_connection("sqlite3:db/development.db")
end

class Tip < ActiveRecord::Base
    has_many :tip_replies
    has_many :refers
    has_many :categories , :through => :refers
end

class Tip_reply < ActiveRecord::Base
    belongs_to :tip
end

class Refer < ActiveRecord::Base
    belongs_to :category
    belongs_to :tip
    belongs_to :question
end

class Question < ActiveRecord::Base
    has_many :answers
    has_many :refers
    has_many :categories , :through => :refers
end

class Category < ActiveRecord::Base
    has_many :refers
    has_many :tips , :through => :refers
    has_many :questions , :through => :refers
end

class Answer < ActiveRecord::Base
    belongs_to :question
end

class User < ActiveRecord::Base
    has_many :tips
    has_many :tips_replies
    has_many :questions
    has_many :answers
end

class Favorite < ActiveRecord::Base
    
end