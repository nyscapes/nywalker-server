require_relative "./model"
# require "georuby"
# require "geo_ruby/ewk"

# Set these for something useful
root = User.create(username: "moacir", password: "1234", email: "moacir@blah.com", name: "Moacir", admin: true, added_on: Time.now)
guest = User.create(username: "guest", password: "violets", email: "guest@blah.com", name: "Guest", admin: false, added_on: Time.now)

first_book = Book.create(slug: "let-the-great-world-spin-2009", author: "Colum McCann", title: "Let the Great World Spin: A Novel", isbn: "9780812973990", year: 2009, added_on: Time.now, url: "http://books.google.com/books?id=_U8Cv5H-qkEC&dq=isbn:9780812973990&hl=&source=gbs_api", cover: "http://books.google.com/books/content?id=_U8Cv5H-qkEC&printsec=frontcover&img=1&zoom=1&edge=none&source=gbs_api", users: [root])

nyc = Place.create(slug: "new-york-city", name: "New York City", added_on: Time.now, lat: 40.71427, lon: -74.00597, user: root, geonameid: "5128581", bounding_box_string: "[-73.51356268564581, 40.34312441457063, 41.085413785429374, -74.4983831143542]", source: "GeoNames", confidence: "3")

["New York City", "New York", "NYC", "The Big Apple", "Gotham"].each do |nickname|
  Nickname.create(name: nickname, place: nyc)
end

chi = Place.create(slug: "chicago", name: "Chicago", added_on: Time.now, lat: 41.85003, lon: -87.65005, user: root, geonameid: "4887398", bounding_box_string: "[-87.523661, 41.644286, 42.023135, -87.940101]", source: "GeoNames", confidence: "3")

["Chicago", "Chi", "The Windy City"].each do |nickname|
  Nickname.create(name: nickname, place: chi)
end

chu = Place.create(slug: "church-street-nyc", name: "Church Street, NYC", added_on: Time.now, lat: 40.7157, lon: -74.0073, user: root, geonameid: "", bounding_box_string: "", source: "https://en.wikipedia.org/wiki/Church_Street_%28Manhattan%29", confidence: "2")
 
Nickname.create(name: "Church Street, NYC", place: chu)

Instance.create(page: 3, sequence: 1, place: chu, book: first_book, user: root)
