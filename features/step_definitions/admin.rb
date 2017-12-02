Given(/^I am an admin$/) do
  @user = create :admin, password: "blarg"
  expect(@user.admin).to be true
end

Then(/^my username is "([^"]*)"$/) do |arg|
  expect(@user.username).to eq arg
end
