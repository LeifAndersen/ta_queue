class User
  include Mongoid::Document
  
  field :username, type: String
  field :token, type: String
  field :location, type: String
  
end
