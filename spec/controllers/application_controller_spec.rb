# frozen_string_literal: true

require "rails_helper"

RSpec.describe ApplicationController do
  it "includes SentryIdentifier" do
    expect(described_class.ancestors.include?(SentryIdentifier)).to be(true)
  end
end
