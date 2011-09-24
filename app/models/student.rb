class Student < User
  belongs_to :board
  field :in_queue, type: Boolean
end
