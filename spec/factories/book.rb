FactoryBot.define do

  factory :book do
    slug "moscow-blues"
    author "Donald Trump"
    title "Moscow Blues"
    isbn "978nnnnnnnnn"
    year 2015
    url "http://whitehouse.gov"
    cover "http://whitehouse.gov/img.png"
  end

  factory :second_book, class: Book do
    slug "moscow-reds"
    author "Jack Reed"
    title "Moscow Reds"
    isbn "978nnnnnnnnm"
    year 1919 
    url "http://whitehouse.gov"
    cover "http://whitehouse.gov/img.png"
    added_on Time.now
  end

  factory :fake_book, class: Book do
    title { Faker::Book.title }
    slug { rand.to_s.split(".").last }
    author { Faker::Book.author }
  end
end
