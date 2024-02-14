# frozen_string_literal: true

require "rails_helper"

RSpec.describe ApplicationController do
  it "includes ErrorContextable" do
    expect(described_class.ancestors.include?(ErrorContextable)).to be(true)
  end
end
