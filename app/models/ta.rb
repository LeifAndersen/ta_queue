class Ta < User
  belongs_to :board, polymorphic: true
  has_one :current_student, class_name:"Student"

  def output_hash
    hash = {}
    hash[:id] = id
    hash[:username] = username
    hash[:current_student] = current_student.nil? ? nil : current_student.username;
    hash
  end

end
