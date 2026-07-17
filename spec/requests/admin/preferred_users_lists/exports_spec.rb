# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin::PreferredUsersLists::Exports" do
  let(:administrator) { create(:administrator) }
  let(:preferred_users_list) { create(:preferred_users_list, :with_users, administrator:) }

  before { sign_in administrator }

  describe "GET /admin/liste-candidats/:preferred_users_list_id/export" do
    subject(:export_request) { get admin_preferred_users_list_export_path(preferred_users_list, format:) }

    context "when the format is XLSX" do
      let(:format) { :xlsx }

      before { export_request }

      it { expect(response).to be_successful }

      it "returns an XLSX file" do
        expect(response.headers["Content-Type"]).to eq(
          "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
        )
      end
    end

    context "when the format is ZIP" do
      let(:format) { :zip }
      let(:zip_id) { "randomly generated uuid" }

      before { allow(SecureRandom).to receive(:uuid).and_return(zip_id) }

      it "enqueues a job to zip the candidates' files" do
        expect { export_request }.to have_enqueued_job(ZipJobApplicationFilesJob).with(
          zip_id:,
          user_ids: preferred_users_list.users.pluck(:id)
        )
      end

      it { is_expected.to redirect_to(admin_zip_file_path(zip_id)) }
    end
  end
end
