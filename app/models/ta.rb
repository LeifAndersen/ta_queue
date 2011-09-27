class Ta < QueueUser
  belongs_to :board
  has_one :student, as: :queue_student

  def output_hash
    hash = {}
    hash[:id] = id
    hash[:username] = username
    #hash[:current_student] = current_student.nil? ? nil : current_student.username;
    hash
  end

end
