require 'sinatra'
require 'sinatra_reloader'
require_relative 'functions'

class MainBlog
  
  get "/" do
    erb :login
  end
  
  get "/sign_up" do
    erb :sign_up
  end
  
  post "/new_user" do
    User.new_guy(params)
    redirect '/'
  end
  
  get "/main/:id" do
    erb :main
  end
  
  get "/compose" do
    erb :compose
  end
  
  post "/save" do
    erb :save
  end
end
  