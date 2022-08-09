# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin::Job_Offers", type: :request do
  before { sign_in create(:administrator) }

  describe "POST /admin/offresdemploi/exports" do
    let(:job_offer_ids) { create_list(:job_offer, 2) }

    context "when a job_offer_ids list is provided" do
      it "export the job offers" do
        post exports_admin_job_offers_path, params: {job_offer_ids: job_offer_ids}
        expect(response).to be_successful
        expect(response.headers["Content-Type"]).to eq(
          "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
        )
      end
    end

    context "when selecting all job offers" do
      it "export the job offers" do
        post exports_admin_job_offers_path, params: {select_all: "on"}
        expect(response).to be_successful
        expect(response.headers["Content-Type"]).to eq(
          "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
        )
      end
    end
  end

  describe "PATCH /admin/offresdemploi/:id/publish" do
    context "when the job offer can be published" do
      let(:job_offer) { create(:job_offer) }

      context "when format is html" do
        subject(:publish_request) { patch publish_admin_job_offer_path(job_offer) }

        it "publishes the job offer" do
          expect { publish_request }.to change { job_offer.reload.state }.to("published")
        end

        it "redirects to job offers" do
          expect(publish_request).to redirect_to(admin_job_offers_path)
        end
      end

      context "when format is js" do
        subject(:publish_request) { patch publish_admin_job_offer_path(job_offer), xhr: true }

        it "publishes the job offer" do
          expect { publish_request }.to change { job_offer.reload.state }.to("published")
        end

        it "renders the template" do
          expect(publish_request).to render_template(:state_change)
        end
      end
    end

    context "when the job offer can't be published" do
      let(:job_offer) { create(:job_offer, organization_description: nil) }

      context "when format is html" do
        subject(:publish_request) { patch publish_admin_job_offer_path(job_offer) }

        it "doesn't publish the job offer" do
          expect { publish_request }.not_to change { job_offer.reload.state }
        end

        it "redirects to job offers" do
          expect(publish_request).to redirect_to(admin_job_offers_path)
        end
      end

      context "when format is js" do
        subject(:publish_request) { patch publish_admin_job_offer_path(job_offer), xhr: true }

        it "doesn't publish the job offer" do
          expect { publish_request }.not_to change { job_offer.reload.state }
        end

        it "renders the template" do
          expect(publish_request).to render_template(:state_unchanged)
        end
      end
    end
  end

  describe "PATCH /admin/offresdemploi/:id" do
    subject(:update_and_publish_request) { patch admin_job_offer_path(job_offer), params: params }

    let(:job_offer) { create(:job_offer) }

    context "when the job offer can be updated and published" do
      let(:params) {
        {
          :job_offer => {title: "title F/H"},
          "commit" => "update_and_publish"
        }
      }

      it "updates and publishes the job offer" do
        expect { update_and_publish_request }.to change { job_offer.reload.state }.to("published")
        expect(job_offer.reload.title).to eq("title F/H")
      end

      it "redirects to job offers" do
        expect(update_and_publish_request).to redirect_to(admin_job_offers_path)
      end
    end

    context "when the job offer can't be updated and published" do
      let(:params) {
        {
          :job_offer => {title: "invalid title"},
          "commit" => "update_and_publish"
        }
      }

      it "doesn't update and publish the job offer" do
        expect { update_and_publish_request }.not_to change { job_offer.reload.state }
        expect(job_offer.reload.title).not_to eq("invalid title")
      end

      it "renders the edit template" do
        expect(update_and_publish_request).to render_template(:edit)
      end
    end
  end
end
