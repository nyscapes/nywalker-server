class App
  namespace '/api/v1' do

    get '/books' do
      if params[:slug]
        book = Book.where(slug: params[:slug]).first
        not_found if book.nil?
        serialize_model(book, include: 'instances').to_json
      else
        serialize_models(Book.all.sort_by{ |b| b.instance_count }.reverse).to_json
      end
    end

    get '/books/:book_id' do
      book = Book[params[:book_id].to_i]
      not_found if book.nil?
      serialize_model(book, include: 'instances').to_json
    end

  end
end
