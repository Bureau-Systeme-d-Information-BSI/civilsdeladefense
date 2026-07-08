# frozen_string_literal: true

require "rails_helper"

RSpec.describe Turbo::Redirection, type: :controller do
  controller(ActionController::Base) do
    include Turbo::Redirection # rubocop:disable RSpec/DescribedClass

    def default_turbo
      redirect_to "/destination"
    end

    def advance_turbo
      redirect_to "/destination", turbo: "advance"
    end

    def disabled_turbo
      redirect_to "/destination", turbo: false
    end
  end

  before do
    routes.draw do
      match "default_turbo", to: "anonymous#default_turbo", via: :all
      match "advance_turbo", to: "anonymous#advance_turbo", via: :all
      match "disabled_turbo", to: "anonymous#disabled_turbo", via: :all
    end
  end

  describe "#redirect_to on an XHR non-GET request" do
    subject(:turbo_redirect) { post :default_turbo, xhr: true }

    before { turbo_redirect }

    it { expect(response.body).to include("Turbo.visit") }

    it { expect(response.body).to include("Turbo.clearCache()") }

    it { expect(response.media_type).to eq("text/javascript") }

    it { expect(response.headers["X-Xhr-Redirect"]).to be_present }

    it { expect(response).to have_http_status(:ok) }
  end

  describe "#redirect_to with turbo set to advance" do
    subject(:advance_redirect) { post :advance_turbo, xhr: true }

    before { advance_redirect }

    it { expect(response.body).to include(%("action":"advance")) }
  end

  describe "#redirect_to with turbo disabled" do
    subject(:disabled_redirect) { post :disabled_turbo, xhr: true }

    before { disabled_redirect }

    it { expect(response).to redirect_to("/destination") }
  end

  describe "#redirect_to on a GET request" do
    subject(:get_redirect) { get :default_turbo, xhr: true }

    before { get_redirect }

    it { expect(response).to redirect_to("/destination") }
  end
end
