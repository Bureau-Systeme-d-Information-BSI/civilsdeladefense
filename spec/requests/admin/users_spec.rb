# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::UsersController, type: :request do
  before { sign_in create(:administrator) }

  describe "POST /admins/candidats/multi_select" do
    describe "downloading the resumes" do
      let(:uuid) { "randomly generated uuid" }
      let!(:user_ids) { create_list(:user, 2).pluck(:id) }

      before do
        allow(SecureRandom).to receive(:uuid).and_return(uuid)
      end

      it "starts a job to zip files and redirects to it, with the right user ids when a user_ids list is provided" do
        expect {
          post multi_select_admin_users_path, params: {resumes: "resumes", user_ids: user_ids}
        }.to have_enqueued_job(ZipJobApplicationFilesJob).with(zip_id: uuid, user_ids: user_ids.reverse)

        expect(response).to redirect_to(admin_zip_file_path(uuid))
      end

      it "starts a job to zip files and redirects to it, with the right user ids when selecting all users" do
        expect {
          post multi_select_admin_users_path, params: {resumes: "resumes", select_all: "on"}
        }.to have_enqueued_job(ZipJobApplicationFilesJob).with(zip_id: uuid, user_ids: user_ids.reverse)

        expect(response).to redirect_to(admin_zip_file_path(uuid))
      end
    end
  end

  describe "DELETE /admins/candidats/:id" do
    it "destroys the user and redirects to index" do
      user = create(:confirmed_user)
      delete admin_user_path(user)

      expect { user.reload }.to raise_error ActiveRecord::RecordNotFound
      expect(response).to redirect_to(admin_users_path)
    end
  end
end
