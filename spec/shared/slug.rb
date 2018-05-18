# frozen_string_literal: true
RSpec.shared_examples "it has a slug" do |object|

  let(:item) { build object.to_sym }

  it "should have a slug." do
    item.save
    expect(item.name.to_url).to eq item.slug
  end
  
end
