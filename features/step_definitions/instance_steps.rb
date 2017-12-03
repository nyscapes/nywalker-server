Given("I created one of the instances for {string}") do |string|
  @book ||= Book.where(title: string).first
  instance_owners = @book.instances.map{|i| i.user.username}
  expect(instance_owners).to include @user.username
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
  last_instance = @book.last_instance
  expect(find("#inputLastPage").value).to eq (last_instance.page).to_s
end

Then("the new instance is on the same page as the previous instance") do
  last_instance = @book.last_instance
  expect(find("#inputLastPage").value).to eq (last_instance.page).to_s
end

Then(/^the sequence is increased by one$/) do
  last_instance = @book.last_instance
  expect(find("#inputSequence").value).to eq (last_instance.sequence + 1).to_s
end
