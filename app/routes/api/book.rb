
class NYWalkerServer

  namespace '/api/v1' do

    get '/books/*/instances' do
      book = Book[params['splat'][0]]
      halt 404 if book.nil?
      serialize_models(Instance.all_sorted_for_book(book)).to_json
    end

  end
end
