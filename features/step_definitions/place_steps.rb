Given("{string} is a saved place") do |string|
  @place = create(:place, name: string)
end
