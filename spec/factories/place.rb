# frozen_string_literal: true
FactoryBot.define do
  factory :place do
    name { Faker::Address.city }
    lat { Faker::Address.latitude }
    lon { Faker::Address.longitude }
    confidence "3"
    source "Geonames"
    user
  end

  factory :fake_place, class: Place do
    name { Faker::Address.city }
  end

end
