class Board
  include Mongoid::Document

  field :title, type: String
  field :password, type: String

  has_many :students, dependent: :destroy
  has_many :tas, dependent: :destroy

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
