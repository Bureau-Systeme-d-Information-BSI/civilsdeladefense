# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin::Users" do
  let(:admin) { create(:administrator) }
  let(:user) { create(:confirmed_user) }

  before { sign_in admin }

  describe "GET /admin/candidats" do
    subject(:index_request) { get admin_users_path }

    it "is successful" do
      index_request
      expect(response).to be_successful
    end

    it "renders the template" do
      expect(index_request).to render_template(:index)
    end
  end

  describe "GET /admin/candidats/:id" do
    it "renders the template" do
      expect(get(admin_user_path(user))).to render_template(:show)
    end

    it "redirects to the user index when the user is not found" do
      expect(get(admin_user_path(-1))).to redirect_to(admin_users_path)
    end
  end

  describe "GET /admin/candidats/:id/photo" do
    subject(:photo_request) { get photo_admin_user_path(user) }

    let(:user) { create(:user, :with_photo) }

    it "is successful" do
      photo_request
      expect(response).to be_successful
    end

    it "shows the user photo" do
      photo_request
      expect(response.headers["Content-Type"]).to eq("image/jpeg")
    end
  end

  describe "GET /admin/candidats/:id/listing(.:format)" do
    subject(:listing_request) { get listing_admin_user_path(user) }

    it "is successful" do
      listing_request
      expect(response).to be_successful
    end

    it "renders the template" do
      expect(listing_request).to render_template(:listing)
    end
  end

  describe "PUT /admin/candidats/:id/update_listing" do
    subject(:update_listing_request) {
      put update_listing_admin_user_path(user), params: {user: {preferred_users_list_ids: [list.id]}}
    }

    let(:list) { create(:preferred_users_list, administrator: admin) }

    it "redirects to the users index" do
      expect(update_listing_request).to redirect_to(admin_users_path)
    end

    it "updates the user's preferred users list" do
      expect { update_listing_request }.to change { user.reload.preferred_users_lists }.to([list])
    end

    it "shows an error if the user is invalid" do
      allow_any_instance_of(User).to receive(:update).and_return(false)

      expect(update_listing_request).to render_template(:listing)
    end
  end

  describe "POST /admin/candidats/multi_select" do
    subject(:multi_select_request) { post multi_select_admin_users_path, params: params }

    let(:user_ids) { create_list(:user, 2).pluck(:id) }

    describe "adding to a list" do
      let(:list) { create(:preferred_users_list, administrator: admin) }

      context "when a user_ids list is provided" do
        let(:params) { {add_to_list: "add_to_list", list_ids: [list.id], user_ids: user_ids} }

        it "redirects to the list" do
          expect(multi_select_request).to redirect_to(admin_preferred_users_list_path(list))
        end

        it "adds the users to the list" do
          multi_select_request
          expect(list.users.pluck(:id).sort).to eq(user_ids.sort)
        end
      end

      context "when selecting all users" do
        let(:params) { {add_to_list: "add_to_list", list_ids: [list.id], select_all: "on"} }

        it "redirects to the list" do
          expect(multi_select_request).to redirect_to(admin_preferred_users_list_path(list))
        end

        it "adds all the users to the list" do
          user = create(:user)

          multi_select_request
          expect(list.users.pluck(:id)).to eq([user.id])
        end
      end

      context "when no list is selected" do
        let(:params) { {add_to_list: "add_to_list", user_ids: user_ids} }

        it "doesn't raise error" do
          expect { multi_select_request }.not_to raise_error
        end

        it "redirects to the users" do
          expect(multi_select_request).to redirect_to(admin_users_path)
        end
      end
    end

    describe "exporting" do
      context "when a user_ids list is provided" do
        let(:params) { {export: "export", user_ids: user_ids} }

        it "downloads the selected users as xlsx file" do
          multi_select_request
          expect(response.headers["Content-Type"]).to eq(
            "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
          )
        end
      end

      context "when selecting all users" do
        let(:params) { {export: "export", select_all: "on"} }

        it "downloads all the users as xlsx file" do
          multi_select_request
          expect(response.headers["Content-Type"]).to eq(
            "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
          )
        end
      end
    end

    describe "downloading the resumes" do
      let(:uuid) { "randomly generated uuid" }

      before { allow(SecureRandom).to receive(:uuid).and_return(uuid) }

      context "when a user_ids list is provided" do
        let(:params) { {resumes: "resumes", user_ids: user_ids} }

        it "starts a job to zip files and redirects to it, with the right user ids when a user_ids list is provided" do
          expect {
            multi_select_request
          }.to have_enqueued_job(ZipJobApplicationFilesJob).with(zip_id: uuid, user_ids: user_ids.reverse)
        end

        it "redirects to the zip file" do
          expect(multi_select_request).to redirect_to(admin_zip_file_path(uuid))
        end
      end

      context "when selecting all users" do
        let(:params) { {resumes: "resumes", select_all: "on"} }

        it "starts a job to zip files and redirects to it, with the right user ids when selecting all users" do
          expect {
            multi_select_request
          }.to have_enqueued_job(ZipJobApplicationFilesJob).with(zip_id: uuid, user_ids: user_ids.reverse)
        end

        it "redirects to the zip file" do
          expect(multi_select_request).to redirect_to(admin_zip_file_path(uuid))
        end
      end
    end

    describe "sending a job offer" do
      let(:job_offer) { create(:job_offer) }

      context "when a user_ids list is provided" do
        let(:params) { {send_job_offer: "send_job_offer", job_offer_identifier: job_offer.identifier, user_ids: user_ids} }

        it "redirects to the users index" do
          expect(multi_select_request).to redirect_to(admin_users_path)
        end

        it "sends the job offer to the selected users" do
          expect_any_instance_of(JobOffer).to receive(:send_to_users).with(User.where(id: user_ids))
          multi_select_request
        end
      end

      context "when selecting all users" do
        let(:params) { {send_job_offer: "send_job_offer", job_offer_identifier: job_offer.identifier, select_all: "on"} }

        it "redirects to the users index" do
          expect(multi_select_request).to redirect_to(admin_users_path)
        end

        it "sends the job offer to all the users" do
          create(:user)

          expect_any_instance_of(JobOffer).to receive(:send_to_users).with(User.all)
          multi_select_request
        end
      end
    end
  end

  describe "DELETE /admins/candidats/:id" do
    subject(:destroy_request) { delete admin_user_path(user) }

    it "destroys the user and redirects to index" do
      expect(destroy_request).to redirect_to(admin_users_path)
      expect { user.reload }.to raise_error ActiveRecord::RecordNotFound
    end

    it "shows an error if the user can't be destroyed" do
      allow_any_instance_of(User).to receive(:destroy).and_return(false)

      destroy_request
      expect(response).to redirect_to(admin_users_path)
    end
  end

  describe "POST /admin/candidats/:id/send_job_offer" do
    context "when the job offer is present" do
      subject(:send_job_offer_request) {
        post send_job_offer_admin_user_path(user, job_offer_identifier: job_offer.identifier)
      }

      let!(:job_offer) { create(:job_offer) }

      it "sends the job offer to the user" do
        expect { send_job_offer_request }.to change { ActionMailer::Base.deliveries.count }.by(1)
      end

      it "redirects to user" do
        expect(send_job_offer_request).to redirect_to(admin_user_path(user))
      end
    end

    context "when the job offer is missing" do
      subject(:send_job_offer_request) { post send_job_offer_admin_user_path(user) }

      it "redirects to user" do
        expect(send_job_offer_request).to redirect_to(admin_user_path(user))
      end
    end
  end

  describe "POST /admin/candidats/:id/suspend" do
    subject(:suspend_request) { post suspend_admin_user_path(user), params: {user: {suspension_reason: ""}} }

    it "redirects to user" do
      expect(suspend_request).to redirect_to(admin_user_path(user))
    end

    it "suspends the user" do
      expect { suspend_request }.to change { user.reload.suspended? }.to(true)
    end
  end

  describe "POST /admin/candidats/:id/unsuspend" do
    subject(:unsuspend_request) { post unsuspend_admin_user_path(user) }

    before { user.suspend! }

    it "redirects to user" do
      expect(unsuspend_request).to redirect_to(admin_user_path(user))
    end

    it "unsuspends the user" do
      expect { unsuspend_request }.to change { user.reload.suspended? }.to(false)
    end
  end
end
