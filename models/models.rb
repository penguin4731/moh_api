require 'bundler/setup'
Bundler.require

if development?
    ActiveRecord::Base.establish_connection("sqlite3:db/development.db")
end

class Tip < ActiveRecord::Base

end

class Tip_reply < ActiveRecord::Base

end

class Refer < ActiveRecord::Base
    
end

class Question < ActiveRecord::Base
    
end

class Category < ActiveRecord::Base
    
end

class Answer < ActiveRecord::Base
    
end