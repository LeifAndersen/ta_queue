namespace :db do
  desc "Fill daboardbase with sample board"

  task :pop => :environment do
    Ta.destroy_all
    Student.destroy_all
    Board.destroy_all

    board = Board.create!(:title => "CS1410", :password => "foobar")
    board.tas.create!(:username => "Parker")
    board.tas.create!(:username => "Michael")
    board.students.create!(:username => "Victor", :location => "lab1-2")
    board.students.create!(:username => "Sarah", :location => "lab1-3")
    board.students.create!(:username => "Allison", :location => "lab1-4")
  end
  
end
