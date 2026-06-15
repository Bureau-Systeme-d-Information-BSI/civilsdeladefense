# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Altcha" do
  describe "GET /altcha" do
    subject(:new_request) { get altcha_path }

    before { new_request }

    it { expect(response).to be_successful }
  end
end
