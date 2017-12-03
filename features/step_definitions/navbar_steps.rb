When(/^I click "([^"]*)" in the navbar$/) do |arg|
  click_link arg, class: "nav-link"
end

Then(/^I should see the navbar$/) do
  expect(page).to have_css "nav.navbar"
end


