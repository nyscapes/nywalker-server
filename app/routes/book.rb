require 'geo_ruby/shp'
require 'dbf'
require 'zip'

class App

  # ALL

  get "/books" do
    @page_title = "All Books"
    books_cache = redis.hmget "book-list", "last-updated", "list"
    @last_updated = last_updated(books_cache[0])
    @books = JSON.parse(books_cache[1], symbolize_names: true)
    mustache :books_show
  end
  
  # CREATE

  get "/books/new" do
    protected_page
    @page_title = "Add New Book"
    mustache :book_new
  end

  post "/books/new" do
    protected_page
    @page_title = "Adding ISBN: #{params[:isbn]}"
    result = GoogleBooks.search("isbn:#{params[:isbn]}").first
    unless result.nil?
      @new_book = { author: result.authors,
                    title: result.title,
                    year: result.published_date[0..3],
                    last_page: result.page_count,
                    cover: result.image_link,
                    link: result.info_link }
    else
      # clumsy kludge for when GoogleBooks returns nothing
      @new_book = { author: "AUTHOR NOT FOUND",
                    title: "TITLE NOT FOUND",
                    year: "",
                    last_page: "",
                    cover: nil,
                    link: "" }
    end
    @isbn = params[:isbn] # sometimes google doesn't return one.
    mustache :book_new_post
  end

  post "/add-book" do
    protected_page
    @page_title = "Saving #{params[:title]}"
    saved_book = Book.new
    saved_book.attributes = { author: params[:author], title: params[:title], isbn: params[:readonlyISBN], cover: params[:cover], url: params[:link], year: params[:year], users: [@user], slug: "#{params[:title]} #{params[:year]}", added_on: Time.now }
    save_object(saved_book, "/books/#{saved_book.slug}")
  end

  # READ
  
  get "/books/:book_slug" do
    @page_title = "#{book.title}"
    instance_cache = redis.hmget "book-#{book.slug}-instances", "last-updated", "list"
    @last_updated = last_updated(instance_cache[0])
    @instances = JSON.parse(instance_cache[1], symbolize_names: true)
    @json_file = book.slug
    mustache :book_show
  end

  get "/books/:book_slug/instances-csv" do
    @page_title = "#{book.title} - CSV"
    @instances = Instance.all(book: book, order: [:page.asc, :sequence.asc]) # place.instances doesn't work?
    salt = Time.now.nsec
    File.open("/tmp/#{book.slug}_instances_#{salt}.csv", "w+:UTF-16LE:UTF-8") do |f|
      csv_string = CSV.generate({col_sep: "\t"}) do |csv|
        csv << ["INSTANCE_ID", "PAGE", "SEQUENCE", "PLACE_NAME_IN_TEXT", "PLACE", "PLACE_ID", "LATITUDE", "LONGITUDE", "SPECIAL", "NOTE", "FLAGGED", "ADDED_ON", "ADDED_BY"]
        @instances.each do |instance|
          csv << [instance.id, instance.page, instance.sequence, instance.text, 
                  instance.place.name,
                  instance.place.id,
                  instance.place.lat,
                  instance.place.lon,
                  instance.special,
                  instance.note,
                  instance.flagged,
                  instance.added_on,
                  instance.user.name]
        end
      end
      f.write "\xEF\xBB\xBF"
      f.write(csv_string)
    end
    send_file "/tmp/#{book.slug}_instances_#{salt}.csv", 
      type: 'application/csv',
      disposition: 'attachment',
      filename: "#{book.slug}_instances_#{salt}.csv",
      stream: false
  end

  get "/books/:book_slug/instances-geojson" do
    @page_title = "#{book.title} - GeoJSON"
    @instances = Instance.all(book: book, order: [:page.asc, :sequence.asc]) # place.instances doesn't work?
    content_type :json
    attachment "#{book.slug}_instances.geo.json"
    geojson = { type: "FeatureCollection" }
    geojson[:features] = @instances.map do |instance|
      { type: "Feature",
        geometry: {
          type: "Point",
          coordinates: [instance.place.lon, instance.place.lat]
        },
        properties: {
          id: instance.id,
          page: instance.page,
          sequence: instance.sequence,
          text: instance.text,
          special: instance.special,
          flagged: instance.flagged,
          added_on: instance.added_on,
          added_by: instance.user.name,
          place_properties: {
            id: instance.place.id,
            name: instance.place.name,
            note: instance.place.note,
            flagged: instance.place.flagged,
            source: instance.place.source,
            geonameid: instance.place.geonameid,
            confidence: instance.place.confidence,
            added_on: instance.place.added_on,
            added_by: instance.place.user.name,
            slug: instance.place.slug
          }
        }
      }
    end
    geojson.to_json
  end

  # get "/books/:book_slug/shp" do
  #   @page_title = "#{book.title} - Shapefile"
  #   @instances = Instance.all(book: book, order: [:page.asc, :sequence.asc]) # place.instances doesn't work?
  #   @places = @instances.places.all(:confidence.not => 0)
  #   # content_type :json
  #   # attachment "#{book.slug}_places.geo.json"
  #   shpfile = GeoRuby::Shp4r::ShpFile.create('places.shp', GeoRuby::Shp4r::ShpType::POINT, [
  #     DBF::Field.new("ID", "N", 10, 0),
  #     DBF::Field.new("NAME", "C", 100),
  #     DBF::Field.new("INSCOUNT", "N", 10, 0),
  #     DBF::Field.new("SPECIAL", "C", 100),
  #     DBF::Field.new("CONFDNCE", "N", 1, 0),
  #     DBF::Field.new("SLUG", "C", 100)
  #   ])
  #   # shpfile = ShpFile.open('places.shp')
  #   @places.each do |place|
  #     count = place.instances.select{ |i| i.book_id == book.id }.count
  #     shpfile.transaction do |tr|
  #       tr.add(GeoRuby::Shp4r::ShpRecord.new(place.geom,
  #                            "ID" => place.id,
  #                            "NAME" => place.name,
  #                            "INSCOUNT" => count,
  #                            "SPECIAL" => place.special,
  #                            "CONFDNCE" => place.confidence,
  #                            "SLUG" => place.slug
  #                           ))
  #     end
  #   end
  #   shpfile.close
  # end

  get "/books/:book_slug/places-geojson" do
    @page_title = "#{book.title} - GeoJSON"
    @instances = Instance.all(book: book, order: [:page.asc, :sequence.asc]) # place.instances doesn't work?
    @places = @instances.places.all(:confidence.not => 0)
    content_type :json
    attachment "#{book.slug}_places.geo.json"
    geojson = { type: "FeatureCollection" }
    geojson[:features] = @places.map do |place|
      is_by_place = instances_by_place(place)
      #count = place.instances.select{ |i| i.book_id == book.id }.count
      nicknames = @instances.select{ |i| i.place == place }.map{ |i| i.text }.uniq.to_sentence
      { type: "Feature",
        geometry: {
          type: "Point",
          coordinates: [place.lon, place.lat]
        },
        properties: {
          id: place.id,
          name: place.name,
          instance_count: is_by_place.count,
          average_instance_page: is_by_place.map{ |i| i.page }.mean,
          instance_stdev: is_by_place.map{ |i| i.page }.standard_deviation,
          average_instance_page_pct: is_by_place.map{ |i| i.page }.mean/book.total_pages,
          instance_stdev_pct: is_by_place.map{ |i| i.page }.standard_deviation/book.total_pages,
          note: place.note,
          flagged: place.flagged,
          source: place.source,
          geonameid: place.geonameid,
          confidence: place.confidence,
          nicknames: nicknames,
          added_on: place.added_on,
          added_by: place.user.name,
          slug: place.slug
        }
      }
    end
    geojson.to_json
  end

  get "/books/:book_slug/places-csv" do
    @page_title = "#{book.title} - CSV"
    @instances = Instance.all(book: book, order: [:page.asc, :sequence.asc]) # place.instances doesn't work?
    @places = @instances.places.all #(:confidence.not => 0) We do want all the places now.
    salt = Time.now.nsec
    File.open("/tmp/#{book.slug}_places_#{salt}.csv", "w+:UTF-16LE:UTF-8") do |f|
      csv_string = CSV.generate({col_sep: "\t"}) do |csv|
        csv << ["PLACE_ID", "NAME", "INSTANCE_COUNT", "AVG_INSTANCE_PG", "INSTANCE_STDEV", "AVG_INSTANCE_PG_PCT", "INSTANCE_STDEV_PCT", "LATITUDE", "LONGITUDE", "SOURCE", "GEONAMEID", "CONFIDENCE", "NICKNAMES", "NOTE", "FLAGGED", "ADDED_ON", "ADDED_BY", "SLUG"]
        @places.each do |place|
          is_by_place = instances_by_place(place)
          nicknames = @instances.select{ |i| i.place == place }.map{ |i| i.text }.uniq.to_sentence
          # nicknames = place.nicknames.map{ |n| n.name }
          csv << [ place.id,
                   place.name,
                   is_by_place.count,
                   is_by_place.map{ |i| i.page }.mean,
                   is_by_place.map{ |i| i.page }.standard_deviation,
                   is_by_place.map{ |i| i.page }.mean/book.total_pages,
                   is_by_place.map{ |i| i.page }.standard_deviation/book.total_pages,
                   place.lat,
                   place.lon,
                   place.source,
                   place.geonameid,
                   place.confidence,
                   nicknames,
                   place.note,
                   place.flagged,
                   place.added_on,
                   place.user.name,
                   place.slug
          ]
        end
      end
      f.write "\xEF\xBB\xBF"
      f.write(csv_string)
    end
    send_file "/tmp/#{book.slug}_places_#{salt}.csv", 
      type: 'application/csv',
      disposition: 'attachment',
      filename: "#{book.slug}_places_#{salt}.csv",
      stream: false
  end

  get "/books/:book_slug/places-special-csv-zip" do
    salt = Time.now.nsec
    @page_title = "#{book.title} - CSV"
    @instances = Instance.all(book: book, order: [:page.asc, :sequence.asc]) # place.instances doesn't work?
    @specials = @instances.map{|i| i.special}.uniq
    @specials.each do |special|
      @places = @instances.all(special: special).places.all(:confidence.not => 0)
      File.open("/tmp/#{special.parameterize}_#{salt}.csv", "w+:UTF-16LE:UTF-8") do |f|
        csv_string = CSV.generate({col_sep: "\t"}) do |csv|
          csv << ["PLACE_ID", "NAME", "INSTANCE_COUNT", "AVG_INSTANCE_PG", "INSTANCE_STDEV", "AVG_INSTANCE_PG_PCT", "INSTANCE_STDEV_PCT", "LATITUDE", "LONGITUDE", "SOURCE", "GEONAMEID", "CONFIDENCE", "NICKNAMES", "NOTE", "FLAGGED", "ADDED_ON", "ADDED_BY", "SLUG"]
          @places.each do |place|
            is_by_place = instances_by_place(place)
            nicknames = @instances.select{ |i| i.place == place }.map{ |i| i.text }.uniq.to_sentence
            # nicknames = place.nicknames.map{ |n| n.name }
            csv << [ place.id,
                     place.name,
                     is_by_place.count,
                     is_by_place.map{ |i| i.page }.mean,
                     is_by_place.map{ |i| i.page }.standard_deviation,
                     is_by_place.map{ |i| i.page }.mean/book.total_pages,
                     is_by_place.map{ |i| i.page }.standard_deviation/book.total_pages,
                     place.lat,
                     place.lon,
                     place.source,
                     place.geonameid,
                     place.confidence,
                     nicknames,
                     place.note,
                     place.flagged,
                     place.added_on,
                     place.user.name,
                     place.slug
            ]
          end
        end
        f.write "\xEF\xBB\xBF"
        f.write(csv_string)
      end
    end
    folder = "/tmp"
    files = @specials.map{|special| "#{special.parameterize}_#{salt}.csv"}
    zipfile = "/tmp/#{book.slug}_special_#{salt}.zip"
    Zip::File.open(zipfile, Zip::File::CREATE) do |zip|
      files.each do |file|
        zip.add(file, folder + '/' + file)
      end
      # zip.get_output_stream("myFile") { |os| os.write "myFile contains just this" }
    end
    send_file "/tmp/#{book.slug}_special_#{salt}.zip", 
      type: 'application/zip',
      disposition: 'attachment',
      filename: "#{book.slug}_special_#{salt}.zip",
      stream: false
  end

  # UPDATE
  
  # DESTROY

  private

  def instances_by_place(place)
    @instances.all(place: place)
  end

  def last_updated(time)
    ((Time.now - Time.parse(time))/60).to_i
  end

end
