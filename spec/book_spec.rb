# frozen_string_literal: true

require "shared/slug"

describe Book do
  let(:book){ create :book }

  context "when it is saved, it" do
    it_should_behave_like "it has a slug", "place"
  end

  describe "Methods" do
  end

  describe "Queries" do
  end

end
