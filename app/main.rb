require 'sinatra/base'
require 'sinatra/reloader'
require_relative './functions'

class MainBlog < Sinatra::Base
  
  get "/" do
    erb :login
  end
  
  post "/login" do
    @user.login(params[:name],params[:password])
    redirect '/main/"#{@user.id}"'
  end
  
  get "/sign_up" do
    erb :sign_up
  end
  
  get "/new_user" do
    User.new_guy(params)
    redirect '/'
  end
  
  get "/main/:id" do
      @user=Users.id.all
    erb :main
  end
  
  get "/compose" do
    erb :compose
  end
  
  post "/save" do
    erb :save
  end
end
  