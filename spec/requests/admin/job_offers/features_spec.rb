# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin::JobOffers::Features" do
  before { sign_in create(:administrator) }

  describe "POST /admin/offresdemploi/:job_offer_id/feature" do
    subject(:feature_request) { post admin_job_offer_feature_path(job_offer) }

    let(:job_offer) { create(:job_offer) }

    context "when administrator can feature" do
      it "marks as featured and redirects back with the success notice" do
        expect { feature_request }.to change { job_offer.reload.featured }.to(true)
        expect(response).to redirect_to(admin_job_offers_path)
        expect(flash[:notice]).to eq(I18n.t("admin.job_offers.features.create.success"))
      end
    end

    context "when administrator cannot feature" do
      before { allow_any_instance_of(Ability).to receive(:can?).and_return(false) }

      it "does not feature the offer and responds with forbidden" do
        expect { feature_request }.not_to change { job_offer.reload.featured }
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe "POST /admin/offresdemploi/feature" do
    subject(:feature_request) { post feature_admin_job_offers_path, params: {job_offer_identifier: identifier} }

    let(:job_offer) { create(:job_offer) }

    context "when the identifier matches an existing offer" do
      let(:identifier) { job_offer.identifier }

      it "marks the matched offer as featured and redirects back with the success notice" do
        expect { feature_request }.to change { job_offer.reload.featured }.from(false).to(true)
        expect(response).to redirect_to(admin_job_offers_path)
        expect(flash[:notice]).to eq(I18n.t("admin.job_offers.features.create.success"))
      end
    end

    context "when the identifier matches no offer" do
      let(:identifier) { "unknown-reference" }

      it "does not change any offer and redirects back with the not_found notice" do
        expect { feature_request }.not_to change { job_offer.reload.featured }
        expect(response).to redirect_to(admin_job_offers_path)
        expect(flash[:notice]).to eq(I18n.t("admin.job_offers.features.create.not_found"))
      end
    end
  end

  describe "DELETE /admin/offresdemploi/:job_offer_id/feature" do
    subject(:unfeature_request) { delete admin_job_offer_feature_path(job_offer) }

    let(:job_offer) { create(:job_offer, featured: true) }

    context "when administrator can feature" do
      it "removes the featured flag and redirects back with the success notice" do
        expect { unfeature_request }.to change { job_offer.reload.featured }.from(true).to(false)
        expect(response).to redirect_to(admin_job_offers_path)
        expect(flash[:notice]).to eq(I18n.t("admin.job_offers.features.destroy.success"))
      end
    end

    context "when administrator cannot feature" do
      before { allow_any_instance_of(Ability).to receive(:can?).and_return(false) }

      it "does not change the offer and responds with forbidden" do
        expect { unfeature_request }.not_to change { job_offer.reload.featured }
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
