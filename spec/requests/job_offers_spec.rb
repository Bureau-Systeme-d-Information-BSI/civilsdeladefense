# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'JobOffers', type: :request do
  describe 'GET /job_offers' do
    it 'works! (now write some real specs)' do
      get job_offers_path
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /job_offers/:id' do
    it 'works! (now write some real specs)' do
      job_offer = create(:job_offer)
      job_offer.publish!
      get job_offer_path(job_offer)
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /job_offers/:id/apply' do
    it 'works! (now write some real specs)' do
      job_offer = create(:job_offer)
      job_offer.publish!
      get apply_job_offer_path(job_offer)
      expect(response).to have_http_status(200)
    end
  end
end
