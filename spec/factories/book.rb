FactoryBot.define do

  factory :book do
    slug "moscow-blues"
    author "Donald Trump"
    title "Moscow Blues"
    isbn "978nnnnnnnnn"
    year 2015
    url "http://whitehouse.gov"
    cover "http://whitehouse.gov/img.png"
    added_on Time.now
  end
end
