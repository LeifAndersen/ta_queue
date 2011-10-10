class QueueUser
  include Mongoid::Document

  field :username, type: String
  field :token, type: String, default: -> { SecureRandom.uuid }
  field :location, type: String

  validates :username, :token, :presence => true
  validates :username, :uniqueness => true

  def as_json options = {}
    output_hash
  end

  def to_xml
    output_hash.to_xml 
  end


  def ta?
    self.class == Ta
  end

  def student?
    self.class == Student
  end

end
