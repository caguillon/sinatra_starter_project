require 'sinatra'
require_relative "user.rb"

enable :sessions

set :session_secret, 'super secret'

get "/login" do
	erb :"authentication/login"
end


post "/process_login" do
	email = params[:email]
	password = params[:password]

	user = User.first(email: email.downcase)

	if(user && user.login(password))
		session[:user_id] = user.id
		redirect "/dashboard"
	else
		erb :"authentication/invalid_login"
	end
end

get "/logout" do
	session[:user_id] = nil
	redirect "/"
end

get "/sign_up" do
	erb :"authentication/sign_up"
end


post "/register" do
	u = User.new
	u.fname = params[:fname]
	u.lname = params[:lname]
	u.email = params[:email].downcase
	u.password =  params[:password]
	u.save

	session[:user_id] = u.id

	erb :"authentication/successful_signup"
end

#This method will return the user object of the currently signed in user
#Returns nil if not signed in
def current_user
	if(session[:user_id])
		@u ||= User.first(id: session[:user_id])
		return @u
	else
		return nil
	end
end

#if the user is not signed in, will redirect to login page
def authenticate!
	if !current_user
		redirect "/login"
	end
end

#if the user is not an admin, will redirect user
def administrate!
	if !current_user.administrator
		redirect "/dashboard"
	end
end

#if the user is not a snapper, will redirect user
def snapify!
	if !current_user.delivery
		redirect "/dashboard"
	end
end

#if the user is an admin
def admin?
	if !current_user.administrator
		return false;
	else
		return true;
	end
end

#if the user is a deliverer
def delivery?
	if !current_user.delivery
		return false;
	else
		return true;
	end
end

#upgrades the user to a delivery in database
def upgrade!
	current_user.update(:delivery => true)
	current_user.save
end