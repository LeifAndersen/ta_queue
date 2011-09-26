class Student < QueueUser
  belongs_to :board, polymorphic: true
  belongs_to :ta, polymorphic: true
  field :in_queue, type: Boolean

  validates :location, :presence => true

  scope :in_queue, where(:in_queue => true)

  def output_hash
    hash = {}
    hash[:id] = id
    hash[:username] = username
    hash[:location] = location
    hash[:in_queue] = in_queue
    hash
  end
end
