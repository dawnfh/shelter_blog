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

post "/" do
  #   in the signup form for the email and password input fields
  @user = User.create(username: params[:username], email: params[:email], password: params[:password])
  
  # since the user is now created we immediately store
  #   their user id in the session because we assume he/she
  #   wants to be logged in immediately and have access to the
  #   logged in content
  session[:user_id] = @user.id
  # this redirects to the get "/" route
  flash[:notice] = "You are now signed up and logged in"
  redirect '/profile'
end

get '/allposts' do
	@posts=Post.all
	@userposts=Post.where(user_id: session[:user_id])

	erb :posts
end

post '/createpost' do
	@posts=Post.create(body: params[:body], user_id: session[:user_id])
  redirect "/allposts"
end


get "/followees" do
  # here we are grabbing all the users that the logged in user is following
  @users = current_user.followees

  # this will output whatever is within the users.erb template
  # notice how this also goes to the posts.erb template
  #   think DRY (Don't Repeat Yourself)
  erb :follows
end

get "/posts/followers" do
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


get "/followers" do
  # here we are grabbing all the users that are following the logged in user 
  @users = current_user.followers

  # this will output whatever is within the users.erb template
  # notice how this also goes to the posts.erb template
  #   think DRY (Don't Repeat Yourself)
  erb :follows
end

# HTTP GET method and "/users/:user_id/follow" action route
get "/users/:followee_id/follow" do
  # here we are creating an association between the current user
  #   who is doing the following and the user you are tryng to follow
  Follow.create(follower_id: session[:user_id], followee_id: params[:followee_id])

  # this redirects to the get "/users/all" route
  # right now its hardcoded to go to this route but it would make
  #   more sense to have this redirect to the page that called it
  #   for our purposes now it will do but there is a more useful
  #   way to do this
  redirect "/followss"
end

# HTTP GET method and "/users/:user_id/unfollow" action route
get "/users/:followee_id/unfollow" do
  @follow = Follow.where(follower_id: session[:user_id], followee_id: params[:followee_id]).first
  @follow.destroy

  redirect "/allposts"
end

get '/logout' do
	session.clear
	flash[:info] = "You are now logged out."
	redirect '/sign-in'
end



