require_relative "./model"

b = Book.first(slug: "let-the-great-world-spin-2009")
Special.create(book: b, field: "Point of View", help_text: "Character point of view.")

[
  [3, 11, "Intro"],
  [11, 73, "Ciaran"],
  [73, 115, "Claire"],
  [115, 157, "Lara"],
  [157, 167, "Walker"],
  [167, 175, "Fernando"],
  [175, 198, "The Kid"],
  [198, 238, "Tillie"],
  [238, 247, "Walker"],
  [247, 275, "Solomon"],
  [275, 285, "Adelita"],
  [285, 325, "Gloria"],
  [325, 351, "Jaslyn"]
].each do |i|
  Instance.all(book: b, :page.gte => i[0], :page.lt => i[1]).each do |instance|
    instance.special = i[2]
    instance.save
  end
end



