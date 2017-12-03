Given(/^I am an admin$/) do
  @user = build :admin
  login_as(@user)
end

