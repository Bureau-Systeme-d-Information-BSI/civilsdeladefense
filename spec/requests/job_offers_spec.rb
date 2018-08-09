require 'rails_helper'

RSpec.describe "JobOffers", type: :request do
  describe "GET /job_offers" do
    it "works! (now write some real specs)" do
      get job_offers_path
      expect(response).to have_http_status(200)
    end
  end
end
