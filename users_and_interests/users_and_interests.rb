require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"
require 'yaml'

before do
  @users = YAML.load_file("users.yaml")
end

get "/" do
  redirect "/users"
end

get "/users" do
  @title = "Users"
  erb :home
end

get "/:name" do
  @title = params[:name].capitalize
  @user_name = params[:name].to_sym
  @email = @users[@user_name][:email]
  @interests = @users[@user_name][:interests]
  
  erb :name
end

helpers do
  def count_interests(users)
    users.values.reduce(0) { |sum, hsh| hsh[:interests].size + sum }
  end
end