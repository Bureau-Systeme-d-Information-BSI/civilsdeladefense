# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin::PreferredUsersLists", type: :request do
  let(:administrator) { create(:administrator) }
  let(:preferred_users_list) { create(:preferred_users_list, :with_users, administrator: administrator) }

  before { sign_in administrator }

  describe "GET /admin/liste-candidats" do
    subject(:index_request) { get admin_preferred_users_lists_path }

    it "renders the template" do
      expect(index_request).to render_template(:index)
    end

    it "lists the preferred users lists" do
      preferred_users_list
      index_request
      expect(response.body).to include(preferred_users_list.name)
    end
  end

  describe "GET /admin/liste-candidats/new" do
    it "renders the template" do
      expect(get(new_admin_preferred_users_list_path)).to render_template(:new)
    end
  end

  describe "POST /admin/liste-candidats" do
    let(:params) { {preferred_users_list: {name: "a list with a name"}} }

    context "when the format is html" do
      subject(:create_request) { post admin_preferred_users_lists_path, params: params }

      it "redirects to the list" do
        expect(
          create_request
        ).to redirect_to(admin_preferred_users_list_path(administrator.reload.preferred_users_lists.first))
      end

      it "creates the list" do
        expect { create_request }.to change(administrator.reload.preferred_users_lists, :count).by(1)
      end

      it "shows an error when the list is invalid" do
        allow_any_instance_of(PreferredUsersList).to receive(:save).and_return(false)
        expect(create_request).to render_template(:new)
      end
    end

    context "when the format is js" do
      subject(:create_request) { post admin_preferred_users_lists_path, params: params, xhr: true }

      it "returns :created" do
        create_request
        expect(response).to have_http_status(:created)
      end

      it "creates the list" do
        expect { create_request }.to change(administrator.reload.preferred_users_lists, :count).by(1)
      end

      it "shows an error when the list is invalid" do
        allow_any_instance_of(PreferredUsersList).to receive(:save).and_return(false)
        expect(create_request).to render_template(:new)
      end
    end
  end

  describe "GET /admin/liste-candidats/:id/edit" do
    it "renders the template" do
      expect(get(edit_admin_preferred_users_list_path(preferred_users_list))).to render_template(:edit)
    end
  end

  describe "PATCH /admin/liste-candidats/:id" do
    let(:new_name) { "a new name" }
    let(:params) { {preferred_users_list: {name: new_name}} }

    context "when the format is html" do
      subject(:update_request) { patch admin_preferred_users_list_path(preferred_users_list), params: params }

      it "redirects to the list" do
        expect(
          update_request
        ).to redirect_to(admin_preferred_users_list_path(administrator.reload.preferred_users_lists.first))
      end

      it "updates the preferred_users_list" do
        expect { update_request }.to change { preferred_users_list.reload.name }.to(new_name)
      end

      it "shows an error when the list is invalid" do
        allow_any_instance_of(PreferredUsersList).to receive(:update).and_return(false)
        expect(update_request).to render_template(:edit)
      end
    end

    context "when the format is js" do
      subject(:update_request) { patch admin_preferred_users_list_path(preferred_users_list), params: params, xhr: true }

      it "returns :created" do
        update_request
        expect(response).to have_http_status(:created)
      end

      it "updates the preferred_users_list" do
        expect { update_request }.to change { preferred_users_list.reload.name }.to(new_name)
      end

      it "shows an error when the list is invalid" do
        allow_any_instance_of(PreferredUsersList).to receive(:update).and_return(false)
        expect(update_request).to render_template(:edit)
      end
    end
  end

  describe "GET /admin/liste-candidats/:id" do
    it "renders the template" do
      expect(get(admin_preferred_users_list_path(preferred_users_list))).to render_template(:show)
    end

    it "searches for users is the parameter is provided" do
      user = preferred_users_list.users.first

      get admin_preferred_users_list_path(preferred_users_list), params: {s: "azertyuiop"}
      expect(response.body).not_to include(user.first_name)

      get admin_preferred_users_list_path(preferred_users_list), params: {s: user.first_name}
      expect(response.body).to include(user.first_name)
    end
  end

  describe "DELETE /admin/liste-candidats/:id" do
    subject(:delete_request) { delete admin_preferred_users_list_path(preferred_users_list) }

    it "redirects to users" do
      expect(delete_request).to redirect_to(admin_users_path)
    end

    it "destroys the list" do
      delete_request
      expect { preferred_users_list.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe "GET /admin/liste-candidats/:id/export" do
    subject(:export_request) {
      get export_admin_preferred_users_list_path(preferred_users_list, format: format)
    }

    context "when format is XLSX" do
      let(:format) { :xlsx }

      it "downloads the list as an XLSX file" do
        export_request
        expect(response).to be_successful
        expect(response.headers["Content-Type"]).to eq(
          "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
        )
      end
    end

    context "when format is ZIP" do
      let(:format) { :zip }

      it "starts a background job to zip the files and redirects to zip file" do
        uuid = "randomly generated uuid"
        allow(SecureRandom).to receive(:uuid).and_return(uuid)

        expect {
          export_request
        }.to have_enqueued_job(ZipJobApplicationFilesJob).with(
          zip_id: uuid,
          user_ids: preferred_users_list.users.pluck(:id)
        )

        expect(response).to redirect_to(admin_zip_file_path(uuid))
      end
    end
  end

  describe "POST /admin/liste-candidats/:id/send_job_offer" do
    subject(:send_job_offer_request) {
      post send_job_offer_admin_preferred_users_list_path(preferred_users_list, job_offer_identifier: job_offer.identifier)
    }

    context "when the job offer exists" do
      let(:job_offer) { create(:job_offer) }

      it "sends the job offer to the users of the list" do
        expect_any_instance_of(JobOffer).to receive(:send_to_users).with(preferred_users_list.users)
        send_job_offer_request
      end

      it "redirects to the preferred users list" do
        expect(send_job_offer_request).to redirect_to(admin_preferred_users_list_path(preferred_users_list))
      end
    end

    context "when the job offer does not exist" do
      let(:job_offer) { instance_double(JobOffer, identifier: "unknown job offer") }

      it "doesn't send the job offer to the users of the list" do
        expect_any_instance_of(JobOffer).not_to receive(:send_to_users)
        send_job_offer_request
      end

      it "redirects to the preferred users list" do
        expect(send_job_offer_request).to redirect_to(admin_preferred_users_list_path(preferred_users_list))
      end
    end
  end
end
