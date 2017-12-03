FactoryBot.define do
  factory :place do
    name { Faker::Address.city }
    slug { Faker::Address.city }.to_s.to_url
    added_on Time.now
    lat { Faker::Address.latitude }
    lon { Faker::Address.longitude }
    confidence "3"
    source "Geonames"
    user
  end

end
