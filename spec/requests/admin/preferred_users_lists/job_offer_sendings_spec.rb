# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin::PreferredUsersLists::JobOfferSendings" do
  let(:administrator) { create(:administrator) }
  let(:preferred_users_list) { create(:preferred_users_list, :with_users, administrator:) }

  before { sign_in administrator }

  describe "POST /admin/liste-candidats/:preferred_users_list_id/job_offer_sending" do
    subject(:create_request) {
      post admin_preferred_users_list_job_offer_sending_path(preferred_users_list, job_offer_identifier: job_offer.identifier)
    }

    context "when the job offer exists" do
      let(:job_offer) { create(:job_offer) }

      it "sends the job offer to the users of the list" do
        expect_any_instance_of(JobOffer).to receive(:send_to_users).with(preferred_users_list.users)
        create_request
      end

      it { is_expected.to redirect_to(admin_preferred_users_list_path(preferred_users_list)) }
    end

    context "when the job offer does not exist" do
      let(:job_offer) { instance_double(JobOffer, identifier: "unknown job offer") }

      it "does not send the job offer to the users of the list" do
        expect_any_instance_of(JobOffer).not_to receive(:send_to_users)
        create_request
      end

      it { is_expected.to redirect_to(admin_preferred_users_list_path(preferred_users_list)) }
    end
  end
end
