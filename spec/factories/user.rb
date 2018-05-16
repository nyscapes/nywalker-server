FactoryBot.define do

  factory :user do
    name "Beetle Juice"
    username "beetlejuice"
    # name { Faker::Name.name }
    # username { Faker::Name.name }
    email { Faker::Internet.email }
    admin false
    added_on Time.now
    firstname "Beetle"
    lastname "Juice"
    password "beetlejuice"
    password_confirmation "beetlejuice"
    api_key { "api_key" }
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

  factory :noapikey, class: User do
    name "Admin"
    username "adminuser"
    email "a@b.com"
    # email { Faker::Internet.email }
    admin true
    password "blarg"
    password_confirmation "blarg"
    api_key nil
  end

end
