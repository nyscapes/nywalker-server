FactoryBot.define do
  factory :place do
    name { Faker::Address.city }
    slug :name.to_s.to_url
    added_on Time.now
    lat { Faker::Address.latitude }
    lon { Faker::Address.longitude }
    confidence "3"
    source "Geonames"
    geonameid "zigmorf"
    note "This is a place."
    flagged false
    what3word "blink.think.drink"
    user
  end

end
