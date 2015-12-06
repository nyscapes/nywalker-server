class App

  # ALL

  get "/books" do
    @page_title = "All Books"
    @books = Book.all
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
    @instances = Instance.all(book: book, order: [:page.asc, :sequence.asc]) # place.instances doesn't work?
    mustache :book_show
  end

  # UPDATE
  
  # DESTROY

end
