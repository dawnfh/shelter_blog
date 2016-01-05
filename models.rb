class User <ActiveRecord::Base
	has_many :posts
	
	validates_length_of :password, minimum: 5
end

class Post <ActiveRecord::Base
		belongs_to :user
		validates_length_of :body, maximum: 150
end

class Follow < ActiveRecord::Base
 
  belongs_to :follower, foreign_key: :follower_id, class_name: User
  belongs_to :followee, foreign_key: :followee_id, class_name: User
end