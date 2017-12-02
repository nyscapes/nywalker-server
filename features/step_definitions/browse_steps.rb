Given(/^I am on the homepage$/) do
  visit '/'
end

Then(/^I should see the Title$/) do
  expect(page).to have_css "h1.display-3", text: "NYWalker"
end

Then(/^I should see a map$/) do
  expect(page).to have_css "div#map"
end

Then(/^I should be on the "([^"]*)" page$/) do |arg|
  expect(page).to have_css "h1", text: arg
end
