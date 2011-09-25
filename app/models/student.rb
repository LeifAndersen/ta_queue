class Student < User
  belongs_to :board, polymorphic: true
  belongs_to :ta, polymorphic: true
  field :in_queue, type: Boolean

  def output_hash
    hash = {}
    hash[:id] = id
    hash[:username] = username
    hash[:location] = location
    hash
  end
end
