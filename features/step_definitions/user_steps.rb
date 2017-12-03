Given("I am allowed to edit the book {string}") do |string|
  @user ||= create :user, admin: true
  # @user ||= create :user
  login_as(@user)
  @book ||= create :book
  allow(@book).to receive(:users).and_return([@user])
end

Then(/^my username is "([^"]*)"$/) do |arg|
  expect(@user.username).to eq arg
end

Then(/^my username is in the navbar$/) do
  expect(page).to have_css "a.nav-link", text: @user.username
end

Given("I log out") do
  logout
end
