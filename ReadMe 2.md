Name: Johnathon L
Created Date: 3/12/2014
Members: 1
Project: Blog, Warm - Up	
Task: Create a working blog using a sql database for storage and with features specified below
Expected Completion: 3/17/2014

Routes
/ - login screen, not sure if I am going to authenticate, but need user id off the bat
/home - main page, display from database list of sites with predefined mood values that match the user
/compose - 2 text entries one for title, one for content
/save - run through a filter (I'll create or find) to give numerical value with specific keywords, assign value to a column in the db

Models

    User
    Post
    Mood
    Heatmap

Views

    login.erb
    main.erb
    newpost.erb

Ideally I would like a heatmap on main but that might be difficult, it may need to be a separate View depending on what solution I can find.

    allposts.erb - Chronological by order post display
