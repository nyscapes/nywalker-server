Given(/^I am an admin$/) do
  @user = create :admin, password: "blarg"
  expect(@user.admin).to be true
end
