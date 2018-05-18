# frozen_string_literal: true
FactoryBot.define do

  factory :book do
    author "Donald Trump"
    title "Moscow Blues"
    isbn "978nnnnnnnnn"
    year 2015
    url "http://whitehouse.gov"
    cover "http://whitehouse.gov/img.png"
  end

  factory :edit_book, class: Book do
    author "Michael Pence"
  end

  factory :second_book, class: Book do
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
    author { Faker::Book.author }
    year { rand 1600..2018 }
  end
end
