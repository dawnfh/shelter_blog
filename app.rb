require "sinatra"
require "sinatra/activerecord"
require "sinatra/flash"
require "./models"

set :database, "sqlite3:shelter_blog.sqlite3"



enable :sessions

#will output display of what is on the index.erb templpate
get '/' do
	erb :index	
end
 #will output display from index which is home & login access.
# get '/login' do
# 	erb :index
# end

post '/login' do
	@user = User.where(username: params[:username]).first
	if @user && @user.password == params[:password]
		sessions[:user_id] = @user.id
		flash[:notice] = "You are logged in."
		redirect '/profile'
	else
		redirect '/'
		flashe[:alert] = "Incorrect password. Do you have an account wth us?"
	end
end

get '/profile' do
	erb :profile
end

get '/post' do
end





# check if user is logged in with a session
def current_user
	if session[:user_id]
		@current_user = User.find(session[:user_id])
	end
end



get '/logout' do
	session.clear
	flash[:info] = "You are now logged out."
	redirect '/sign-in'
end
