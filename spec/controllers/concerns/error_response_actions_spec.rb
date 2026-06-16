# frozen_string_literal: true

require "rails_helper"

RSpec.describe ErrorResponseActions, type: :controller do
  controller(ApplicationController) do
    def raise_not_found = raise ActiveRecord::RecordNotFound

    def raise_not_available = raise JobOfferNotAvailableAnymore.new(job_offer_title: "x")

    def trigger_internal_error = internal_error
  end

  before do
    routes.draw do
      match "raise_not_found", to: "anonymous#raise_not_found", via: :all
      match "raise_not_available", to: "anonymous#raise_not_available", via: :all
      match "trigger_internal_error", to: "anonymous#trigger_internal_error", via: :all
    end
  end

  describe "#resource_not_found" do
    before { perform }

    context "with xml format" do
      subject(:perform) { get :raise_not_found, format: :xml }

      it { expect(response).to have_http_status(:not_found) }
    end

    context "with json format" do
      subject(:perform) { get :raise_not_found, format: :json }

      it { expect(response).to have_http_status(:not_found) }
    end
  end

  describe "#resource_not_available_anymore" do
    before { perform }

    context "with html format" do
      subject(:perform) { get :raise_not_available }

      it { expect(response).to have_http_status(:not_found) }
    end

    context "with xml format" do
      subject(:perform) { get :raise_not_available, format: :xml }

      it { expect(response).to have_http_status(:not_found) }
    end

    context "with json format" do
      subject(:perform) { get :raise_not_available, format: :json }

      it { expect(response).to have_http_status(:not_found) }
    end
  end

  describe "#internal_error" do
    before { perform }

    context "with html format" do
      subject(:perform) { get :trigger_internal_error }

      it { expect(response).to have_http_status(:internal_server_error) }
    end

    context "with xml format" do
      subject(:perform) { get :trigger_internal_error, format: :xml }

      it { expect(response).to have_http_status(:internal_server_error) }
    end

    context "with json format" do
      subject(:perform) { get :trigger_internal_error, format: :json }

      it { expect(response).to have_http_status(:internal_server_error) }
    end
  end
end
