require 'sqlite3'
#@db.execute("INSERT INTO todos (name, done) VALUES ('#{params[:item]}', 0)")
@db=SQLite3::Database.open("blog")
a=File.open('positive_words.txt', "r")
@db.execute("DROP TABLE positive")
@db.execute("CREATE TABLE positive (word, value)")
a.each_line do |line|
  insert=line.strip
  #@db.execute("INSERT INTO todos (name, done) VALUES ('#{params[:item]}', 0)")
  @db.execute("INSERT INTO positive (word, value) VALUES ('#{insert}', 1)")
  puts insert
end
a.close