require 'sinatra/base'
require 'sinatra/reloader'
require_relative './functions'

class MainBlog < Sinatra::Base
  
  get "/" do
    erb :login,:layout => :layout_unsigned
  end
  
  get "/sign_up" do
    erb :sign_up, :layout => :layout_unsigned
  end
  
  #Client.find_by! first_name: 'Lifo'
  post "/login" do
    if User.where(:name=> params[:name]).first
        @user=User.login(params[:name],params[:password])
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
    if @user.password!=params[:new_password] && params[:new_password]!="" 
        @user.change_password([:new_password], params[:id], @user.auth) 
    end
    redirect to "/main/#{@user.id}"  
  end
  
  
  post "/new_user" do
    User.new_guy(params)
    redirect '/'
  end
  
  get "/main/:id" do
    @user=User.find(params[:id])
    erb :main
  end
  
  get "/compose/:id" do
    @user=User.find(params[:id])
    id=@user.id
    erb :compose
  end
  
  post "/save/:id" do
    @user=User.find(params[:id])
    @post=Post.new_post(@user.id, params[:title], params[:post])
    #@user=User.where(:name => name, :password=>password).first
    erb :save
  end
  
  get "/all_posts/:id" do
    @user=User.find(params[:id])
    @map_main=Heat.new
    a=@map_main.coord_map
    erb :allposts
  end
  
  after do
    ActiveRecord::Base.connection.close
  end
end
  