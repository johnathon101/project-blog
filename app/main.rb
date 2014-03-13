require 'sinatra/base'
require 'sinatra/reloader'
require_relative './functions'

class MainBlog < Sinatra::Base
  
  get "/" do
    erb :login
  end
  
  #Client.find_by! first_name: 'Lifo'
  get "/login" do
    @user=User.login(params[:name],params[:password])
    redirect "/main/#{@user}"
  end
  
  get "/sign_up" do
    erb :sign_up
  end
  
  get "/new_user" do
    User.new_guy(params)
    redirect '/'
  end
  
  get "/main/:id" do
    @user=User.find{params[:id]}
    erb :main
  end
  
  get "/compose/:id" do
    @user=User.find{params[:id]}
    id=@user.id
    binding.pry
    erb :compose
  end
  
  get "/save/:id" do
    @user=User.find{params[:id]}
    @post=Post.new_post(@user.id, params[:title], params[:post])
    erb :save
  end
end
  