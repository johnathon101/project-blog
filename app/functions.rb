require 'active_record'
require 'logger'
require 'pry'
require './modules'

#Everything User, create, modify name, email, location, mood settings.
#name, location(ST), email, password
class User
  #user (id, name, email, location, mood_pref, password, auth, is_auth)
  def self.new_guy(sign_up)
    new_user= User.new(name:=> name, email:=>email, location:=>location, mood_pref:=>mood_pref, password:=>password, auth:=>rand(500), is_auth:=>0)
    new_user.save
  end
  
  def change_name(new_name, auth)
    user.id(name:=>new_name)
  end
  
  def change_email(new_email, auth)
    user.name(email:=>email) 
  end
  
  def change_location(new_location, auth)
    user.id(location:=>location)
  end
  
  def change_mood_pref(new_mood_pref, auth)
    user.id(mood_pref:=>new_mood_pref)
  end
  
  def change_password(new_password, auth)
    user.id(password:=>new_password)
  end
  
  
  #db table users
end

#Contains all posts, user id who wrote it, runs through filter to get mood value
#title(varchar), post(txt) limit 510, user_id
class Post
  #posts db (id, user_id, title, post)
  def self.new_post
    new_post=Post.new(id:=>user_id, title:=>title, post:=>post)
  end
  
  def self.get_mood
    words=user.id[:post].split(' ')
    #words.each match table_of_values add to a sum for mood scale
  end
  
  def self.my_posts
    #Psuedo SELECT * ON posts WHERE user.id = user_id
    #posts=user.id
  end
end

#Runs script through Post object to get a mood value and assigns it back to post with user
#post_id, mood
class Mood
  
  def self.new_mood
    new_mood=Mood.new(id:=>user.id, title:=>title, mood:=>mood)
  #need values of words with different connotations, ran through the post text and assign a value to any hits from the words to text. Maybe create a table of words with values we're looking for and join them to get a sum?
  #db table moods
  def self.blend_mood
    #return matches of post.mood and user.mood_pref and display results cleanly
    #psuedo SELECT * ON posts WHERE moods.rating=user.mood_pref
  end
  
end

#Create a general mood of area based on user location and mood of posts from that location, join mood, location.
class HeatMap
  #db table heat_maps
end