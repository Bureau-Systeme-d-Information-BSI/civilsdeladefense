# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin::Users::JobOfferSendings" do
  let(:admin) { create(:administrator) }
  let(:user) { create(:confirmed_user) }

  before { sign_in admin }

  describe "POST /admin/candidats/:user_id/job_offer_sending" do
    subject(:create_request) {
      post admin_user_job_offer_sending_path(user, job_offer_identifier: job_offer&.identifier)
    }

    context "when the job offer is present" do
      let(:job_offer) { create(:job_offer) }

      it { expect { create_request }.to change { ActionMailer::Base.deliveries.count }.by(1) }

      it { is_expected.to redirect_to(admin_user_path(user)) }
    end

    context "when the job offer is missing" do
      let(:job_offer) { nil }

      it { is_expected.to redirect_to(admin_user_path(user)) }
    end
  end
end
