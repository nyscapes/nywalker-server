FactoryBot.define do

  factory :user do
    name "Beetle Juice"
    username "beetlejuice"
    email { Faker::Internet.email }
    admin false
    added_on Time.now
    firstname "Beetle"
    lastname "Juice"
    password "beetlejuice"
    password_confirmation "beetlejuice"
    api_key { "api_key" }
  end

  factory :fake_user, class: User do
    name { Faker::Name.first_name }
    username { "#{name.downcase}-#{rand}" }
    email { "#{username}@example.com" }
    password "beetlejuice"
    password_confirmation { password }
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
