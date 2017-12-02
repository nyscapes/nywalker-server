Given(/^I am an admin$/) do
  @user = build :admin
  login_as(@user)
end

Then(/^my username is "([^"]*)"$/) do |arg|
  expect(@user.username).to eq arg
end

Then(/^my username is in the navbar$/) do
  expect(page).to have_css "a.nav-link", text: @user.username
end
