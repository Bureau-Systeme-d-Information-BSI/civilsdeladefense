# frozen_string_literal: true

require "rails_helper"
require "rack/test"

RSpec.describe "JobOffers", type: :request do
  describe "GET /job_offers" do
    it "returns 200 when fetching the job offers page" do
      get job_offers_path
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /job_offers/:id" do
    it "returns 200 when fetching a specific job offers page" do
      job_offer = create(:job_offer)
      job_offer.publish!
      get job_offer_path(job_offer)
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /job_offers/apply?id=:id" do
    it "returns 200 when fetching a specific job offers application page" do
      job_offer = create(:job_offer)
      job_offer.publish!
      get apply_job_offers_path(id: job_offer.slug)
      expect(response).to have_http_status(200)
    end
  end

  describe "the requests support CORS headers" do
    include Rack::Test::Methods

    it "returns the response CORS headers" do
      get root_path, nil, "HTTP_ORIGIN" => "*"
      expect(last_response.headers["Access-Control-Allow-Origin"]).to be_nil

      get job_offers_path(format: :json), nil, "HTTP_ORIGIN" => "*"
      expect(last_response.headers["Access-Control-Allow-Origin"]).to eq("*")
    end

    scenario "Send the CORS preflight OPTIONS request" do
      headers = {
        "HTTP_ORIGIN" => "*",
        "HTTP_ACCESS_CONTROL_REQUEST_METHOD" => "GET",
        "HTTP_ACCESS_CONTROL_REQUEST_HEADERS" => "test"
      }

      options root_path, nil, headers
      expect(last_response.headers["Access-Control-Allow-Origin"]).to be_nil
      expect(last_response.headers["Access-Control-Allow-Methods"]).to be_nil
      expect(last_response.headers["Access-Control-Allow-Headers"]).to be_nil

      options job_offers_path(format: :json), nil, headers
      expect(last_response.headers["Access-Control-Allow-Origin"]).to eq("*")
      expect(last_response.headers["Access-Control-Allow-Methods"]).to eq("GET, OPTIONS")
      expect(last_response.headers["Access-Control-Allow-Headers"]).to eq("test")
    end
  end
end
