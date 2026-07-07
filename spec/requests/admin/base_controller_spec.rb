# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin::BaseController" do
  subject(:search_cities) { get admin_cities_path, params: {q: "Paris"}, as: :turbo_stream }

  before do
    sign_in administrator
    allow(Net::HTTP).to receive(:get).and_return({"features" => []}.to_json)
  end

  after { ENV.delete("BACK_OFFICE_FUNCTIONAL_ADMIN_ONLY") }

  context "when the BACK_OFFICE_FUNCTIONAL_ADMIN_ONLY flag is disabled" do
    let(:administrator) { create(:administrator, roles: [:hr_manager]) }

    before do
      ENV["BACK_OFFICE_FUNCTIONAL_ADMIN_ONLY"] = "false"
      search_cities
    end

    it { expect(response).to be_successful }
  end

  context "when the BACK_OFFICE_FUNCTIONAL_ADMIN_ONLY flag is enabled" do
    before { ENV["BACK_OFFICE_FUNCTIONAL_ADMIN_ONLY"] = "true" }

    context "when the administrator is a functional administrator" do
      let(:administrator) { create(:administrator, roles: [:functional_administrator]) }

      before { search_cities }

      it { expect(response).to be_successful }
    end

    context "when the administrator is not a functional administrator" do
      let(:administrator) { create(:administrator, roles: [:hr_manager]) }

      before { search_cities }

      it { expect(response).to redirect_to(new_administrator_session_path) }
    end
  end
end
