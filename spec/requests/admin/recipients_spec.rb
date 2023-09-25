# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin::Recipients", type: :request do
  let(:job_offer) { create(:job_offer) }

  before { sign_in create(:administrator) }

  describe "GET /index" do
    let!(:job_application_a) { create(:job_application, job_offer: job_offer, user: create(:user, first_name: "Grant", last_name: "Hill")) }
    let!(:job_application_b) { create(:job_application, job_offer: job_offer, user: create(:user, first_name: "Hugh", last_name: "Grant")) }
    let!(:job_application_c) { create(:job_application, job_offer: job_offer, user: create(:user, email: "totoro@miyazaki.jp")) }

    it "is successful" do
      get admin_job_offer_recipients_path(job_offer, format: :json, s: "aaa")
      expect(response).to be_successful
    end

    it "returns an empty array when the search string is missing" do
      get admin_job_offer_recipients_path(job_offer, format: :json)
      expect(response.parsed_body).to eq([])
    end

    it "returns no results when the search string doesn't match any recipients" do
      get admin_job_offer_recipients_path(job_offer, format: :json, s: "aaa")
      expect(response.parsed_body).to eq([])
    end

    it "searches for matching recipients (aka job applications which user name matches the query)" do
      get admin_job_offer_recipients_path(job_offer, format: :json, s: "Grant")
      expect(response.parsed_body).to match([
        {
          id: job_application_b.id,
          user: {first_name: job_application_b.user.first_name, last_name: job_application_b.user.last_name, email: job_application_b.user.email}
        }.with_indifferent_access,
        {
          id: job_application_a.id,
          user: {first_name: job_application_a.user.first_name, last_name: job_application_a.user.last_name, email: job_application_a.user.email}
        }.with_indifferent_access
      ])
    end

    it "searches for a given recipient, by name (aka job applications which user name matches the query)" do
      get admin_job_offer_recipients_path(job_offer, format: :json, s: "Hugh")
      expect(response.parsed_body).to match([
        {
          id: job_application_b.id,
          user: {first_name: job_application_b.user.first_name, last_name: job_application_b.user.last_name, email: job_application_b.user.email}
        }.with_indifferent_access
      ])
    end

    it "searches for a given recipient, by email (aka job applications which user name matches the query)" do
      get admin_job_offer_recipients_path(job_offer, format: :json, s: "totoro")
      expect(response.parsed_body).to match([
        {
          id: job_application_c.id,
          user: {first_name: job_application_c.user.first_name, last_name: job_application_c.user.last_name, email: job_application_c.user.email}
        }.with_indifferent_access
      ])
    end
  end

  describe "POST /index" do
    let!(:job_application) { create(:job_application, job_offer: job_offer) }

    it "is successful" do
      post admin_job_offer_recipients_path(job_offer), xhr: true, params: {recipient: {id: job_application.id}}
      expect(response).to be_successful
    end
  end
end
