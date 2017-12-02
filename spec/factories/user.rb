FactoryBot.define do

  factory :user do
    name { Faker::Name.name }
    username { Faker::Name.name }
    email { Faker::Internet.email }
    admin false
    added_on Time.now
    firstname "Beetle"
    lastname "Juice"
    password "beetlejuice"
    password_confirmation "beetlejuice"
  end

  factory :admin, class: User do
    name "Admin"
    username "adminuser"
    email "a@b.com"
    # email { Faker::Internet.email }
    admin true
    password "blarg"
    password_confirmation "blarg"
  end

end
