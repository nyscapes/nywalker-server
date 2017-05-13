FactoryGirl.define do

  factory :user do
    name { Faker::Name.name }
    username "beetlejuice"
    email { Faker::Internet.email }
    admin false
    added_on Time.now
    firstname "Beetle"
    lastname "Juice"
    password "beetlejuice"
    password_confirmation "beetlejuice"
  end

end
