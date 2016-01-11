require "sinatra"
require "sinatra/activerecord"
require "sinatra/flash"
require "psych"
require "./models"



configure(:development){set :database, "sqlite3:shelter_blog.sqlite3"}

enable :sessions


# check if user is logged in with a session
def current_user
	if session[:user_id]
		@current_user = User.find(session[:user_id])
	end
end

#will output display of what is on the index.erb templpate
get '/' do
	erb :index	
end
 #will output display from index which is home & login access.

post '/' do
	@user = User.where(username: params[:username]).first
	if @user && @user.password == params[:password]
		session[:user_id] = @user.id
		flash[:notice] = "You are logged in."
		redirect '/profile'
	else
		flash[:alert] = "Incorrect password. Do you have an account wth us?"
		redirect '/'
	end
end

get '/profile' do
	@user=current_user
	erb :profile
end

post '/profile' do
@user= current_user
@user=User.create(username: params[:id])
end

post '/' do
 
  @user = User.create(username: params[:username], email: params[:email], password: params[:password])
  

  session[:user_id] = @user.id

  flash[:notice] = "You are now signed up and logged in"
  redirect '/profile'
end

get '/allposts' do
	@posts=Post.all
	
	erb :posts
end

post '/createpost' do
	@posts=Post.create(body: params[:body], user_id: session[:user_id])
  redirect '/allposts'
end


get '/followees' do
  
  @users = current_user.followees


  erb :follows
end

get '/posts/followers' do
  # this loads all the created posts from the logged in user's
  #   followers
  # puts into an array.
  @posts = current_user.followers.inject([]) do |posts, follower|
    # this takes the current follower's posts and add them to the
    #   posts array we are building
    posts << follower.posts
  end

  #   http://ruby-doc.org/core-2.2.3/Array.html#method-i-flatten
  @posts.flatten!
  erb :posts
end




get '/followers' do

  @users = current_user.followers

  
  erb :follows
end

get '/users/:followee_id/follow' do

  Follow.create(follower_id: session[:user_id], followee_id: params[:followee_id])
  redirect '/follows'
end


get '/users/:followee_id/unfollow' do
  @follow = Follow.where(follower_id: session[:user_id], followee_id: params[:followee_id]).first
  @follow.destroy

end

get '/logout' do
	session.clear
	flash[:info] = "You are now logged out."
	redirect '/sign-in'
end



