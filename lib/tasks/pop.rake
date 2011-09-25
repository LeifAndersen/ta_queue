namespace :db do
  desc "Fill daboardbase with sample board"

  task :pop => :environment do
    Ta.destroy_all
    Student.destroy_all
    Board.destroy_all

    board = Board.create!(:title => "CS1410", :password => "foobar")
    board.tas.create!(:username => "Parker", :token => SecureRandom.uuid)
    board.tas.create!(:username => "Michael", :token => SecureRandom.uuid)
    board.students.create!(:username => "Victor", :location => "lab1-2", :token => SecureRandom.uuid)
    board.students.create!(:username => "Sarah", :location => "lab1-3", :token => SecureRandom.uuid)
    board.students.create!(:username => "Allison", :location => "lab1-4", :token => SecureRandom.uuid)
  end
  
end
