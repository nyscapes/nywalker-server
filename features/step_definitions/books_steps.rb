Then(/^I should see a list of books$/) do
  # expect(all("tr").length).to eq 2
  pending
end

Given(/^there is a book "([^"]*)"$/) do |arg1|
  @book = create :book#, user: @user
  expect(@book.title).to eq arg1
end

Given(/^I am on the "([^"]*)" book page$/) do |arg1|
  expect(@book.title).to eq arg1
  visit "/books/#{@book.slug}"
end

Given("{int} instances exist for {string}") do |int, string|
  expect(@book.title).to eq string
  create_list(:instance, int, book: @book)
  expect(Instance.where(book: @book).all.length).to eq int
end
