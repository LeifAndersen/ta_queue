class QueueUser
  include Mongoid::Document

  field :username, type: String
  field :token, type: String
  field :location, type: String

  validates :username, :token, :presence => true
  validates :username, :uniqueness => true

  before_create :create_token

  def as_json options = {}
    output_hash
  end

  def ta?
    self.class == Ta
  end

  def student?
    self.class == Student
  end

  private
    
    def create_token
      token = SecureRandom.uuid
    end
end
