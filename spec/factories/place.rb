FactoryBot.define do
  factory :place do
    name { Faker::Address.city }
    slug { "#{Faker::Address.city}-#{rand(10000)}" }.to_s.to_url
    added_on Time.now
    lat { Faker::Address.latitude }
    lon { Faker::Address.longitude }
    confidence "3"
    source "Geonames"
    user
  end

  factory :fake_place, class: Place do
    name { Faker::Address.city }
    slug { "#{Faker::Address.city}-#{rand(10000)}" }.to_s.to_url
  end

end
