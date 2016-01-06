require "sinatra"
require "sinatra/activerecord"
require "sqlite3"
require "sinatra/flash"

require "./models"

set :database, "sqlite3:shelter_blog.sqlite3"



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
	"Hello"
	erb :profile
end

# HTTP GET method and "/signup" action route
# get "/signin" do
   
#   erb :index
# end

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
  redirect "/profile"
end




get '/post' do
  erb :posts
end




get '/logout' do
	session.clear
	flash[:info] = "You are now logged out."
	redirect '/sign-in'
end



