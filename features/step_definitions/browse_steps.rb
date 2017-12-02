Given(/^I am on the homepage$/) do
  visit '/'
end

Given(/^I am on the "([^"]*)" page$/) do |arg|
  visit "/#{arg.downcase}"
end

When(/^I click on the "([^"]*)" button$/) do |arg1|
  click_link arg1
end

Then(/^I should see the Title$/) do
  expect(page).to have_css "h1.display-3", text: "NYWalker"
end

Then(/^I should see an "([^"]*)" link$/) do |arg|
  # expect(page).to have_css "a.btn", text: arg
  expect(page).to have_content arg
end

Then(/^I should see a map$/) do
  expect(page).to have_css "div#map"
end

Then(/^I should be on the "([^"]*)" page$/) do |arg|
  expect(page).to have_css "h1", text: arg
end
