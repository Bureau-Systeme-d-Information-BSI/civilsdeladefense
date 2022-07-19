# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin::PreferredUsersLists", type: :request do
  let(:preferred_users_list) { create(:preferred_users_list, :with_users) }

  before { sign_in preferred_users_list.administrator }

  describe "GET /admin/liste-candidats/:id/export(.:format)" do
    context "when format is XLSX" do
      it "downloads the list as an XLSX file" do
        get export_admin_preferred_users_list_path(preferred_users_list, format: :xlsx)
        expect(response).to be_successful
        expect(response.headers["Content-Type"]).to eq(
          "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
        )
      end
    end

    context "when format is ZIP" do
      it "starts a background job to zip the files and redirects to zip file" do
        uuid = "randomly generated uuid"
        allow(SecureRandom).to receive(:uuid).and_return(uuid)

        expect {
          get export_admin_preferred_users_list_path(preferred_users_list, format: :zip)
        }.to have_enqueued_job(ZipJobApplicationFilesJob).with(
          zip_id: uuid,
          user_ids: preferred_users_list.users.pluck(:id)
        )

        expect(response).to redirect_to(admin_zip_file_path(uuid))
      end
    end
  end
end
