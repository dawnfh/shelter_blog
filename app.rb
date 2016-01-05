require "sinatra"
require "sinatra/activerecord"
require "sinatra/flash"

set :database, "sqlite3:shelter_blogdb.sqlite3"

enable	:sessions

require "./models"

get '/' do 
	erb :index
end

post '/' do
	@user=User.where(username: params[:username]).first
	if @user.password== params[:password]
		session[:user_id] = @user.user_id
		flash[:notice] = "login is correct"
	else
		flash[:notice] = "username and/or password incorrect"

end
redirect '/'
end



get '/profile' do
	erb :profile
end	



