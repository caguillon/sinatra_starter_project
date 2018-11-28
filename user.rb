require 'data_mapper' # metagem, requires common plugins too.

# need install dm-sqlite-adapter
# if on heroku, use Postgres database
# if not use sqlite3 database I gave you
if ENV['DATABASE_URL']
  DataMapper::setup(:default, ENV['DATABASE_URL'] || 'postgres://localhost/mydb')
else
  DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/app.db")
end

class User
    include DataMapper::Resource
    property :id, Serial

    property :email, String
    property :password, String
    property :created_at, DateTime
    property :fname, String
    property :lname, String
    
    #type of user - is there a better way for this?
    property :administrator, Boolean, :default => false
    property :consumer, Boolean, :default => false
    property :delivery, Boolean, :default => false

    def login(password)
    	return self.password == password
    end
end

# Perform basic sanity checks and initialize all relationships
# Call this when you've defined all your models
DataMapper.finalize

# automatically create the user table
User.auto_upgrade!

