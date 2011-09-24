class Board
  include Mongoid::Document

  field :title, type: String
  field :password, type: String

  has_many :students
  has_many :tas
end
