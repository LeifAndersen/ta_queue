class Student < QueueUser
  belongs_to :board, polymorphic: true
  belongs_to :ta, polymorphic: true
  field :in_queue, type: Boolean

  validates :location, :presence => true

  def output_hash
    hash = {}
    hash[:id] = id
    hash[:username] = username
    hash[:location] = location
    hash
  end
end
