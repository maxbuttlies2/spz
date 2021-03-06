class User::User
  include MongoMapper::Document
  key :name, String
  key :first_name, String
  key :mail, String
  key :password, String
  key :active, Boolean
  key :level, Integer

  validates_presence_of :first_name
  validates_presence_of :name
  validates_presence_of :mail
  validates_presence_of :password

end
