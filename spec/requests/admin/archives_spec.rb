# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::ArchivesController, type: :request do
  let(:job_offer) { create(:job_offer) }

  before { sign_in create(:administrator) }

  describe "GET /new" do
    it "shows the archive modal" do
      get new_admin_job_offer_archive_path(job_offer), xhr: true
      expect(response).to be_successful
      expect(response.body).to include(I18n.t(".admin.archives.form.title"))
    end
  end

  describe "POST /create" do
    context "when an archiving reason is provided" do
      let(:archiving_reason) { create(:archiving_reason) }
      let(:params) {
        {
          job_offer: {
            archiving_reason_id: archiving_reason.id
          }
        }
      }

      it "archives the job offer" do
        expect {
          post admin_job_offer_archives_path(job_offer), params: params, xhr: true
        }.to change { job_offer.reload.archived? }.to(true)
      end

      it "stores the archiving reason" do
        expect {
          post admin_job_offer_archives_path(job_offer), params: params, xhr: true
        }.to change { job_offer.reload.archiving_reason }.to(archiving_reason)
      end
    end

    context "when the archiving reason is not provided" do
      let(:params) {
        {
          job_offer: {
            archiving_reason_id: ""
          }
        }
      }

      it "archives the job offer" do
        expect {
          post admin_job_offer_archives_path(job_offer), params: params, xhr: true
        }.to change { job_offer.reload.archived? }.to(true)
      end

      it "doesn't store the archiving reason" do
        expect {
          post admin_job_offer_archives_path(job_offer), params: params, xhr: true
        }.not_to change { job_offer.reload.archiving_reason }
      end
    end
  end
end
