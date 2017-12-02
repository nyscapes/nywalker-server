Given("I created one of the instances for {string}") do |string|
  pending # Write code here that turns the phrase above into concrete actions
end

When("I fill in instance information for {string}") do |string|
  fill_in "Place", with: "#{string} -- {#{string}}"
  fill_in "Place name in text", with: string
  @instance_count = Instance.count
end

Then(/^the instance is saved$/) do
  expect(Instance.count).to eq @instance_count + 1
end

When(/^I type "([^"]*)" in the "([^"]*)" field$/) do |arg1, arg2|
    pending # Write code here that turns the phrase above into concrete actions
end

Then(/^the form fills in "([^"]*)" as the nickname$/) do |arg1|
    pending # Write code here that turns the phrase above into concrete actions
end

Then(/^fills in the full "([^"]*)" pattern$/) do |arg1|
    pending # Write code here that turns the phrase above into concrete actions
end


Then(/^I see the last instance$/) do
    pending # Write code here that turns the phrase above into concrete actions
end

Then(/^the new instance is on the same page as the previous$/) do
    pending # Write code here that turns the phrase above into concrete actions
end

Then(/^the sequence is increased by one$/) do
    pending # Write code here that turns the phrase above into concrete actions
end
