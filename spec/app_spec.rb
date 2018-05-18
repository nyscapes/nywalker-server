# frozen_string_literal: true
require 'spec_helper'

describe "NYWalker" do
  it "should allow access to the front page" do
    get '/'
    expect(last_response).to be_ok
  end
end
