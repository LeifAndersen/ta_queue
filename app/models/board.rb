class Board
  include Mongoid::Document

  field :title, type: String
  field :password, type: String
  field :frozen, type: Boolean
  field :active, type: Boolean

  has_many :students, dependent: :destroy
  has_many :tas, dependent: :destroy

  validates :title, :uniqueness => true
  validates :title, :format => { :with => /^[a-zA-Z_\-0-9]*$/, :message => "The title of a queue must contain only numbers, letters, _, and -"}

  def state
    hash = Hash.new
    hash[:tas] = tas.as_jsn
    hash[:students] = students.in_queue.as_jsn
    hash
  end

  def to_param
    self.title
  end
end
