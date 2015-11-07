When(/^I create an instance$/) do
  @instance = Instance.new
end

Then(/^it should exist$/) do
  expect(@instance).to exist
end
