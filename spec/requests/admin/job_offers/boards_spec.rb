# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin::JobOffers::Boards" do
  describe "GET /admin/offresdemploi/:job_offer_id/board" do
    subject(:board_request) { get admin_job_offer_board_path(job_offer) }

    context "when logged in as 'admin' administrator" do
      let(:job_offer) { create(:job_offer) }

      before do
        sign_in create(:administrator)
        board_request
      end

      it { expect(response).to be_successful }
    end

    context "when logged in as Grand Employeur administrator" do
      let(:administrator) { create(:administrator, role: nil) }
      let(:job_offer) do
        create(:job_offer, job_offer_actors_attributes: [{administrator_id: administrator.id, role: :grand_employer}])
      end

      before do
        sign_in administrator
        board_request
      end

      it { expect(response).to be_successful }
    end
  end
end
