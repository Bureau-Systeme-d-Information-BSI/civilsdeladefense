# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin::Job_Offers" do
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
      shared_examples "unpublishable job offer" do
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

      context "when organization_description is missing" do
        let(:job_offer) do
          build(:job_offer, organization_description: nil).tap { |jo| jo.save(validate: false) }
        end

        it_behaves_like "unpublishable job offer"
      end

      context "when recruitment_process is missing" do
        let(:job_offer) do
          build(:job_offer, recruitment_process: nil).tap { |jo| jo.save(validate: false) }
        end

        it_behaves_like "unpublishable job offer"
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

    context "when updating new attributes" do
      subject(:update_request) { patch admin_job_offer_path(job_offer), params: params }

      let(:params) do
        {
          job_offer: {
            ict_tct: true,
            asc: true,
            cover_lettre_required: true,
            positions_count: 3
          }
        }
      end

      it "saves ict_tct" do
        expect { update_request }.to change { job_offer.reload.ict_tct }.from(false).to(true)
      end

      it "saves asc" do
        expect { update_request }.to change { job_offer.reload.asc }.from(false).to(true)
      end

      it "saves cover_lettre_required" do
        expect { update_request }.to change { job_offer.reload.cover_lettre_required }.from(false).to(true)
      end

      it "saves positions_count" do
        expect { update_request }.to change { job_offer.reload.positions_count }.from(1).to(3)
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

  describe "GET /admin/offresdemploi (js)" do
    subject(:index_request) { get admin_job_offers_path(format: :js), xhr: true }

    before { create(:job_offer) }

    it { expect(index_request).to render_template(:index) }
  end

  describe "GET /admin/offresdemploi/featured" do
    subject(:featured_request) { get featured_admin_job_offers_path }

    before do
      create(:published_job_offer, featured: true)
      featured_request
    end

    it { expect(response).to be_successful }
  end

  describe "GET /admin/offresdemploi (search)" do
    subject(:index_request) { get admin_job_offers_path, params: {s: "Developer"} }

    before do
      create(:job_offer, title: "Developer F/H")
      index_request
    end

    it { expect(response).to be_successful }
  end

  describe "GET /admin/offresdemploi/:id/export" do
    subject(:export_request) { get export_admin_job_offer_path(job_offer) }

    let(:job_offer) { create(:published_job_offer) }

    before do
      create(:job_application, job_offer:)
      export_request
    end

    it { expect(response).to be_successful }

    it {
      expect(response.headers["Content-Type"]).to eq(
        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
      )
    }
  end

  describe "GET /admin/offresdemploi/new" do
    subject(:new_request) do
      get new_admin_job_offer_path, headers: {"HTTP_REFERER" => referer}
    end

    let(:referer) { "http://www.example.com/admin/offresdemploi" }

    context "when the organization requires job offer terms and none is selected" do
      before do
        Organization.first.update!(
          job_offer_term_title: "Title",
          job_offer_term_subtitle: "Subtitle",
          job_offer_term_warning: "Warning"
        )
        create(:job_offer_term)
      end

      it { expect(new_request).to redirect_to(referer) }
    end
  end

  describe "POST /admin/offresdemploi/:id/transfer" do
    subject(:transfer_request) do
      post transfer_admin_job_offer_path(job_offer), params: {transfer_email:}
    end

    let(:job_offer) { create(:job_offer) }

    context "when the target administrator exists" do
      let(:transfer_email) { create(:administrator).email }

      it { expect(transfer_request).to redirect_to(admin_job_offers_path) }

      it "transfers the ownership" do
        expect { transfer_request }.to change { job_offer.reload.owner.email }.to(transfer_email)
      end
    end

    context "when the target administrator does not exist" do
      let(:transfer_email) { "unknown@example.com" }

      before { transfer_request }

      it { expect(response).to render_template(:new_transfer) }

      it { expect(response).to have_http_status(:unprocessable_content) }
    end
  end

  describe "POST /admin/offresdemploi/:id/send_to_list" do
    subject(:send_to_list_request) do
      post send_to_list_admin_job_offer_path(job_offer),
        params: {preferred_users_lists: [preferred_users_list.id]}
    end

    let(:job_offer) { create(:job_offer) }
    let(:preferred_users_list) { create(:preferred_users_list, :with_users) }

    it { expect(send_to_list_request).to redirect_to(admin_job_offers_path) }

    it "sends the job offer to the list users" do
      expect { send_to_list_request }.to change { ActionMailer::Base.deliveries.size }.by(3)
    end
  end

  describe "POST /admin/offresdemploi (create_and_publish with an administrator actor)" do
    subject(:create_and_publish_request) do
      post admin_job_offers_path, params: {job_offer: attributes, commit: "create_and_publish"}
    end

    let(:actor_administrator) { create(:administrator, inviter: nil) }

    let(:attributes) do
      build(:job_offer).attributes.merge(
        "employer_id" => create(:employer).id,
        "category_id" => create(:category).id,
        "level_id" => create(:level).id,
        "job_offer_actors_attributes" => {
          "0" => {role: "employer", administrator_attributes: {email: actor_administrator.email}}
        }
      )
    end

    it { expect { create_and_publish_request }.to change(JobOffer, :count).by(1) }

    it "sets the actor administrator inviter to the current administrator" do
      expect { create_and_publish_request }.to change { actor_administrator.reload.inviter }.from(nil)
    end
  end
end
