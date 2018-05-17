require 'uri'

RSpec.configure do |rspec|
  # on by default in RSpec 4, but…
  rspec.shared_context_metadata_behavior = :apply_to_host_groups
end

RSpec.shared_context "api", shared_context: :metadata do
  let(:apiurl) { "/api/v1" }
  let(:accept) { { "HTTP_ACCEPT" => "application/vnd.api+json" } }

  def getjsonapi(url, params = nil)
    if params.nil?
      params = ""
    elsif params.class == Fixnum
      params = "/#{params}"
    elsif params.class == Hash
      params = "?#{URI.encode_www_form(params)}"
    end
    get apiurl + url + params, {}, accept
  end

  def delivery
    JSON.parse(last_response.body)
  end

end

RSpec.shared_context "posting", shared_context: :metadata do
  include_context "api"
  let(:user) { create :user }
  let(:data) { { username: user.username, api_key: "api_key" } }
  let(:data_json) { accept.merge "CONTENT_TYPE" => "application/vnd.api+json" }
end

RSpec.configure do |rspec|
  rspec.include_context "api", include_shared: true
  rspec.include_context "posting", include_shared: true
end
