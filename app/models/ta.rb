class Ta < QueueUser
  belongs_to :board

  has_one :student, :class_name => "Student", dependent: :nullify

  def output_hash
    hash = {}
    hash[:id] = id
    hash[:username] = username
    hash[:student] = self.student.nil? ? nil : self.student.username;
    hash
  end

end
