require 'active_record'
require 'logger'
require 'pry'
require 'heatmap'

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
    value=0
    real_sum=article_sum.inject {|sum, i| sum + i}
    sum=real_sum.inject{|sum, i|sum+=i}
    if sum>5
      value=5
    elsif sum>2 && sum<=5
      value=4
    elsif sum>=0 && sum<=2
      value=3
    elsif sum>-3 && sum<0
      value=2
    elsif sum<=-3
      value=1
    else
      value=3
    end

    return value
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
class Comment
  
  
end

#Create a general mood of area based on user location and mood of posts from that location, join mood, location.
class Heat < ActiveRecord::Base

  def initialize
    
    @map=Heatmap.new
  end
  def build_coordinates
    d0=["CT","ME","MA","NH","RH","VT"]#ATL NE
    d1=["NJ","NY","PA"]#N ATL NE
    d2=["IL","IN","MI","OH","WI"]#MW NCentral
    d3=["IA","KS","MN","MO","NE","ND","SD"]#MIDWEST
    d4=["DE","FL","GA","MD","NC","SC","VA","WV"]#MID ATL S
    d5=["AL","KY","MS","TN"]#MIDWEST S MID CENTRAL
    d6=["AR","LA","OK","TX"]#SOUTH SOUTH WEST
    d7=["AZ","CO","ID","MT","NV","NM","UT","WY"]#MTN
    d8=["AK","CA","HI","OR","WA"]#WEST COAST
    @locations =[d0,d1,d2,d3,d4,d5,d6,d7,d8]
    @sum_totals=Array.new(9,1)
    i=0
    @locations.each do |place|
      div_total=User.joins(:posts).where(:location => place)
      sum=1
        if div_total!=[]
            div_total.each do |post|
              #post is the user here, here I need to get posts from user and sum the moods
              post_value=Post.joins(:user).where(:user_id=>post.id).first
              sum+=post_value.mood
            end
            sum_totals[i]=sum
        end
        i+=1
      end
      return sum_totals
  end  

  def coord_map
    built=build_coordinates
    built[0].times do
      @map << Heatmap::Area.new(9,4)
    end
    built[1].times do
      @map << Heatmap::Area.new(8,3)
    end
    built[2].times do
      @map << Heatmap::Area.new(6,3)
    end
    built[3].times do
      @map << Heatmap::Area.new(5,3)
    end
    built[4].times do
      @map << Heatmap::Area.new(8,1)
    end
    built[5].times do
      @map << Heatmap::Area.new(7,2)
    end
    built[6].times do
      @map << Heatmap::Area.new(5,2)
    end
    built[7].times do
      @map << Heatmap::Area.new(3,2)
    end
    built[8].times do
      @map << Heatmap::Area.new(1,2)
    end
    @map.output('simple.png')
  end
end
