Then(/^I should see a list of books$/) do
  # expect(all("tr").length).to eq 2
  pending
end

Given(/^there is a book "([^"]*)"$/) do |arg1|
  @book = create :book
  expect(@book.title).to eq arg1
end

Given(/^I am on the "([^"]*)" book page$/) do |arg1|
  expect(@book.title).to eq arg1
  visit "/books/#{@book.slug}"
end

Given(/^instances exist for "([^"]*)"$/) do |arg1|
  pending
end
