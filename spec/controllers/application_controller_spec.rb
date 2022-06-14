# frozen_string_literal: true

require "rails_helper"

RSpec.describe ApplicationController, type: :controller do
  it "includes SentryIdentifier" do
    expect(ApplicationController.ancestors.include?(SentryIdentifier)).to be(true)
  end
end
