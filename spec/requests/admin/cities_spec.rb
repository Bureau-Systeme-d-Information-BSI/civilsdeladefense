# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin::Cities" do
  before do
    sign_in create(:administrator)
    allow(Net::HTTP).to receive(:get).and_return(api_response.to_json)
  end

  let(:api_response) do
    {
      "features" => [
        {
          "properties" => {
            "id" => "75056",
            "label" => "Paris",
            "city" => "Paris",
            "context" => "75, Paris, Île-de-France",
            "postcode" => "75001"
          }
        },
        {
          "properties" => {
            "id" => "13055",
            "label" => "Marseille",
            "city" => "Marseille",
            "context" => "13, Bouches-du-Rhône, Provence-Alpes-Côte d'Azur",
            "postcode" => "13001"
          }
        }
      ]
    }
  end

  describe "GET /admin/cities" do
    subject(:search_cities) { get admin_cities_path, params: params, as: :turbo_stream }

    before { search_cities }

    context "when query is provided" do
      let(:params) { {q: "Paris"} }

      it { expect(response).to be_successful }

      it "returns cities" do
        expect(response.body).to include("Paris")
        expect(response.body).to include("Marseille")
      end
    end

    context "when query is too short" do
      let(:params) { {q: "Pa"} }

      it { expect(response).to be_successful }

      it "returns an empty list" do
        expect(response.body).not_to include("Paris")
        expect(response.body).not_to include("Marseille")
      end
    end

    context "when no query is provided" do
      let(:params) { {} }

      it { expect(response).to be_successful }

      it "returns an empty list" do
        expect(response.body).not_to include("Paris")
        expect(response.body).not_to include("Marseille")
      end
    end
  end

  describe "GET /admin/cities/:id" do
    subject(:show_city) { get admin_city_path(city_id) }

    before { show_city }

    context "when the city exists" do
      let(:city_id) { "75056" }

      it { expect(response).to be_successful }
      it { expect(response.parsed_body).to include("id" => "75056", "label" => "Paris") }
    end

    context "when no city matches" do
      let(:city_id) { "99999" }

      it { expect(response).to be_successful }
      it { expect(response.parsed_body).to be_nil }
    end
  end
end
