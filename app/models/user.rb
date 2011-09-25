class User
  include Mongoid::Document
  
  field :username, type: String
  field :token, type: String
  field :location, type: String

  validates :username, :token, :presence => true
  validates :username, :uniqueness => true

  def self.as_jsn
    arr = []
    all.each do |user|
      arr << user.output_hash
    end
    arr
  end

  def ta?
    self.class == Ta
  end

  def student?
    self.class == Student
  end

end
