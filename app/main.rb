require 'sinatra/base'
require 'sinatra/reloader'
require_relative './functions'

class MainBlog < Sinatra::Base
  
  get "/" do
    erb :login
  end
  
  #Client.find_by! first_name: 'Lifo'
  post "/login" do
    @user=User.login(params[:name],params[:password])
    if @user
      redirect to "/main/#{@user}"
    else
      redirect to "/sign_up"
    end
  end
  
  get "/update_settings/:id" do
    @user=User.find(params[:id])
    erb :settings
  end
  
  post "/save_settings/:id" do
    @user=User.find(params[:id])
    if @user.name!=params[:new_name] && params[:new_name]!="" 
      @user.change_name(params[:new_name], params[:id], @user.auth)
    end
    if @user.email!=params[:new_email] && params[:new_email]!="" 
       @user.change_email(params[:new_email], params[:id], @user.auth)
    end   
    if @user.location!=params[:new_location] && params[:new_location]!="" 
       @user.change_location(params[:new_location], params[:id], @user.auth)
    end
    if @user.mood_pref!=params[:new_mood_pref] && params[:new_mood_pref]!="" 
       @user.change_mood_pref(params[:mood_pref], params[:id], @user.auth)
    end
    if @user.passsword!=params[:new_password] && params[:new_password]!="" 
        @user.change_password([:new_password], params[:id], @user.auth) 
    end
      
  end
  
  get "/sign_up" do
    erb :sign_up
  end
  
  post "/new_user" do
    User.new_guy(params)
    redirect '/'
  end
  
  get "/main/:id" do
    @user=User.find(params[:id])
    binding.pry
    erb :main
  end
  
  get "/compose/:id" do
    @user=User.find(params[:id])
    id=@user.id
    binding.pry
    erb :compose
  end
  
  post "/save/:id" do
    @user=User.find(params[:id])
    @post=Post.new_post(@user.id, params[:title], params[:post])
    erb :save
  end
end
  