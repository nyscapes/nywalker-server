FactoryBot.define do
  # sequence :sequence do |n|
  #   "#{n}"
  # end

  factory :instance do
    page { Faker::Number.digit }
    # sequence 2
    text { Faker::Address.city }
    added_on Time.now
    flagged false
    note { Faker::Lorem.sentence }
    special "Special"
    place
    user
    # book
  end

end
