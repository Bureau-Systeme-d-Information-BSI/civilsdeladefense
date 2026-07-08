# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Altcha" do
  describe "GET /altcha" do
    subject(:new_request) { get altcha_path }

    before do
      allow(Altcha).to receive(:hmac_key).and_return("test-hmac-key")
      new_request
    end

    it { expect(response).to be_successful }
  end
end
