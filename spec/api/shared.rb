RSpec.configure do |rspec|
  # on by default in RSpec 4, but…
  rspec.shared_context_metadata_behavior = :apply_to_host_groups
end

RSpec.shared_context "api", shared_context: :metadata do
  let(:apiurl) { "/api/v1" }
  let(:accept) { { "HTTP_ACCEPT" => "application/vnd.api+json" } }
end

RSpec.configure do |rspec|
  rspec.include_context "api", include_shared: true
end
