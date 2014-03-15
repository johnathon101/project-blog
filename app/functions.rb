require 'active_record'
require 'logger'
require 'pry'

  
ActiveRecord::Base.establish_connection(
      :adapter  => 'sqlite3', 
      :database => 'blog'
  )
ActiveRecord::Base.logger = Logger.new(STDERR)

ActiveRecord::Schema.define do
  unless ActiveRecord::Base.connection.tables.include? 'users'     
    create_table :users do |table|
       table.column :name, :string 
       table.column :email, :string
       table.column :password, :string
       table.column :location, :string
       table.column :mood_pref, :integer
       table.column :auth, :integer
    end
   end
   unless ActiveRecord::Base.connection.tables.include? 'posts'
     create_table :posts do |table|
       table.column :user_id, :integer
       table.column :title, :string
       table.column :post, :text
       table.column :mood, :integer
     end
   end
   unless ActiveRecord::Base.connection.tables.include? 'moods'
     create_table :moods do |table|
       table.column :post_id, integer
       table.column :mood, integer
     end
   end
end
#Everything User, create, modify name, email, location, mood settings.
#name, location(ST), email, password
class User < ActiveRecord::Base
  has_many :posts
  attr_accessor :flag
  def intitalize
    @flag=flag
  end
  
  def self.new_guy(sign_up)
    name=sign_up[:name]
    email=sign_up[:email]
    location=sign_up[:location]
    mood_pref=sign_up[:mood_pref]
    password=sign_up[:password]
    new_user= User.new({:name=> name, :email=> email, :location=>location, :mood_pref=>mood_pref, :password=>password, :auth=>rand(500)})
    new_user.save
  end
  
  
  def self.login(name, password)
    @user=User.where(:name => name, :password=>password).first
    #user.update_attributes(:auth=>1)
    return @user.id
  end
  
  def change_name(new_name, id, auth)
    @user=User.find(id)
    @user.update_attributes({:name=>new_name})
  end
  
  def change_email(new_email, id, auth)
    @user=User.find(id)
    @user.update_attributes({:email=>new_email}) 
  end
  
  def change_location(new_location, id, auth)
    @user=User.find(id)
    @user.update_attributes({:location=>new_location})
  end
  
  def change_mood_pref(new_mood_pref, id, auth)
    @user=User.find(id)
    @user.update_attributes({:mood_pref=>new_mood_pref})
  end
  
  def change_password(new_password, id, auth)
    @user=User.find(id)
    @user.update_attributes({:password=>new_password})
  end
end

#Contains all posts, user id who wrote it, runs through filter to get mood value
#title(varchar), post(txt) limit 510, user_id
class Post < ActiveRecord::Base
  belongs_to :user
  
  def self.new_post(user_id, title, content)
    mood=Post.get_mood(content)
    new_post=Post.new(:user_id=>user_id, :title=>title, :post=>content, :mood=> mood)
    new_post.save
    return new_post.id
  end
  
  def self.get_mood(content)
    @db=SQLite3::Database.open("blog")
    val_array=Array.new
    words=[]
    article_sum=0
    words_array=content.split(' ')
    words_array.each do |a_word|
      fix_word=a_word.strip.downcase.gsub(/[^A-Za-z0-9]+/, '')
      puts a_word
      val_array<<@db.execute("SELECT value FROM dictionary WHERE word IS '#{fix_word}'")[0]
    end
    article_sum=val_array.compact
    sum=0
    real_sum=article_sum.inject {|sum, i| sum + i}
    sum=real_sum.inject{|sum, i|sum+=i}
    return sum
  end
  
  def self.my_posts(id)
    #@user=User.where(:name => name, :password=>password).first
    @post=Post.where(:user_id => id)
    #Psuedo SELECT * ON posts WHERE user.id = user_id
    #posts=user.id
  end
end

#Runs script through Post object to get a mood value and assigns it back to post with user
#post_id, mood
class Mood < ActiveRecord::Base
  #CREATE TABLE moods (id integer def pr(args)
    
  #endimary key autoincrement, user_id integer, title varchar, mood integer);

  
  def self.new_mood(user_id, title, mood)
    new_mood=Mood.new(:id=>user.id, :title=>title, :mood=>mood)
  #need values of words with different connotations, ran through the post text and assign a value to any hits from the words to text. Maybe create a table of words with values we're looking for and join them to get a sum?
  #db table moods
  end
  def self.blend_mood
    #return matches of post.mood and user.mood_pref and display results cleanly
    #psuedo SELECT * ON posts WHERE moods.rating=user.mood_pref
  end
  
end

#Create a general mood of area based on user location and mood of posts from that location, join mood, location.
class HeatMap
  #db table heat_maps
end
binding.pry
#CREATE TABLE users (id integer primary key autoincrement, name varchar, email varchar, location varchar, mood_pref integer, password varchar, auth integer, is_auth integer);

#CREATE TABLE posts (id integer primary key autoincrement, user_id integer, title varchar, post text)
#posts db (id, user_id, title, post)