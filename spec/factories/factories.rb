FactoryGirl.define do

  sequence :username do |n|
    "username #{n}"
  end

  sequence :location do |n|
    "location #{n}"
  end

  sequence :title do |n|
    "title#{n}"
  end

  factory :queue_user do
    username { Factory.next :username }
    token { SecureRandom.uuid }
    password "some_password"
  end

  factory :student, :parent => :queue_user do
    location { Factory.next :location }
  end

  factory :ta, :parent => :queue_user do
  end

  factory :board do
    title { Factory.next :title }
    password "some_password"
  end


end
