# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::RecipientsController, type: :request do
  let(:job_offer) { create(:job_offer) }

  before { sign_in create(:administrator) }

  describe "GET /index" do
    let(:user_a) { create(:user, first_name: "Grant", last_name: "Hill") }
    let(:user_b) { create(:user, first_name: "Hugh", last_name: "Grant") }
    let(:user_c) { create(:user, email: "totoro@miyazaki.jp") }
    let!(:job_application_a) { create(:job_application, job_offer: job_offer, user: user_a) }
    let!(:job_application_b) { create(:job_application, job_offer: job_offer, user: user_b) }
    let!(:job_application_c) { create(:job_application, job_offer: job_offer, user: user_c) }

    it "is successful" do
      get admin_job_offer_recipients_path(job_offer, format: :json, s: "aaa")
      expect(response).to be_successful
    end

    it "returns an empty array when the search string is missing" do
      get admin_job_offer_recipients_path(job_offer, format: :json)
      expect(JSON.parse(response.body)).to eq([])
    end

    it "returns no results when the search string doesn't match any recipients" do
      get admin_job_offer_recipients_path(job_offer, format: :json, s: "aaa")
      expect(JSON.parse(response.body)).to eq([])
    end

    it "searches for matching recipients (aka job applications which user name matches the query)" do
      get admin_job_offer_recipients_path(job_offer, format: :json, s: "Grant")
      expect(JSON.parse(response.body)).to match([
        {
          id: job_application_b.id,
          user: {first_name: user_b.first_name, last_name: user_b.last_name, email: user_b.email}
        }.with_indifferent_access,
        {
          id: job_application_a.id,
          user: {first_name: user_a.first_name, last_name: user_a.last_name, email: user_a.email}
        }.with_indifferent_access
      ])
    end

    it "searches for a given recipient, by name (aka job applications which user name matches the query)" do
      get admin_job_offer_recipients_path(job_offer, format: :json, s: "Hugh")
      expect(JSON.parse(response.body)).to match([
        {
          id: job_application_b.id,
          user: {first_name: user_b.first_name, last_name: user_b.last_name, email: user_b.email}
        }.with_indifferent_access
      ])
    end

    it "searches for a given recipient, by email (aka job applications which user name matches the query)" do
      get admin_job_offer_recipients_path(job_offer, format: :json, s: "totoro")
      expect(JSON.parse(response.body)).to match([
        {
          id: job_application_c.id,
          user: {first_name: user_c.first_name, last_name: user_c.last_name, email: user_c.email}
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
