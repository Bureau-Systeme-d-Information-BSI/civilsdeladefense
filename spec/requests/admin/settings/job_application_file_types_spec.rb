# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin::Settings::JobApplicationFileTypes" do
  let(:create_attributes) do
    {
      visibility_rules_attributes: [
        {by: "administrator", state: :initial, _destroy: "0"},
        {by: "user", state: :initial, _destroy: "0"}
      ]
    }
  end

  before { sign_in create(:administrator) }

  it_behaves_like "an admin setting", :job_application_file_type, :name, "a new name"
  it_behaves_like "a movable admin setting", :job_application_file_type

  describe "GET /admin/parametres/job_application_file_types/new" do
    subject(:new_request) { get new_admin_settings_job_application_file_type_path }

    before { new_request }

    it "renders the form" do
      expect(response).to render_template(:new)
      expect(assigns(:visibility_rules_for_administrator).length).to eq(JobApplication.states.count)
      expect(assigns(:visibility_rules_for_user).length).to eq(JobApplication.states.count)
      expect(assigns(:visibility_rules_for_administrator)).to all(be_administrator)
      expect(assigns(:visibility_rules_for_user)).to all(be_user)
    end
  end

  describe "GET /admin/parametres/job_application_file_types/:id/edit" do
    subject(:edit_request) { get edit_admin_settings_job_application_file_type_path(job_application_file_type) }

    let(:job_application_file_type) { create(:job_application_file_type) }

    it "renders the form" do
      edit_request
      expect(response).to render_template(:edit)
      expect(assigns(:visibility_rules_for_administrator).length).to eq(JobApplication.states.count)
      expect(assigns(:visibility_rules_for_user).length).to eq(JobApplication.states.count)
    end

    context "when the file type already has visibility rules" do
      before do
        create(:visibility_rule, job_application_file_type: job_application_file_type, by: :administrator, state: :initial)
        create(:visibility_rule, job_application_file_type: job_application_file_type, by: :user, state: :accepted)
        edit_request
      end

      it "shows existing administrator rules as persisted (checked)" do
        initial_rule = assigns(:visibility_rules_for_administrator).find { |r| r.state == "initial" }
        expect(initial_rule).to be_persisted
      end

      it "shows missing administrator states as new records (unchecked)" do
        phone_meeting_rule = assigns(:visibility_rules_for_administrator).find { |r| r.state == "phone_meeting" }
        expect(phone_meeting_rule).to be_new_record
      end

      it "shows existing user rules as persisted (checked)" do
        accepted_rule = assigns(:visibility_rules_for_user).find { |r| r.state == "accepted" }
        expect(accepted_rule).to be_persisted
      end

      it "shows missing user states as new records (unchecked)" do
        phone_meeting_rule = assigns(:visibility_rules_for_user).find { |r| r.state == "phone_meeting" }
        expect(phone_meeting_rule).to be_new_record
      end
    end
  end

  describe "POST /admin/parametres/job_application_file_types" do
    subject(:create_request) { post admin_settings_job_application_file_types_path, params: }

    let(:params) do
      {
        job_application_file_type: attributes_for(:job_application_file_type).merge(
          visibility_rules_attributes: [
            {by: "administrator", state: :initial, _destroy: "0"},
            {by: "user", state: :initial, _destroy: "0"}
          ]
        )
      }
    end

    it "creates the visibility rules" do
      expect { create_request }.to change(VisibilityRule, :count).by(2)
      expect(response).to redirect_to(admin_settings_job_application_file_types_path)
    end

    context "when visibility rules are missing" do
      let(:params) do
        {job_application_file_type: attributes_for(:job_application_file_type)}
      end

      it "does not create the job application file type" do
        expect { create_request }.not_to change(JobApplicationFileType, :count)
        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe "PATCH /admin/parametres/job_application_file_types/:id" do
    let(:job_application_file_type) { create(:job_application_file_type) }

    context "when adding a visibility rule" do
      subject(:update_request) { patch admin_settings_job_application_file_type_path(job_application_file_type), params: }

      let(:params) do
        {
          job_application_file_type: {
            visibility_rules_attributes: [
              {by: "administrator", state: :phone_meeting, _destroy: "0"}
            ]
          }
        }
      end

      it "creates the new visibility rule" do
        expect { update_request }.to change { job_application_file_type.reload.visibility_rules.count }.by(1)
        expect(response).to redirect_to(admin_settings_job_application_file_types_path)
      end
    end

    context "when updating notification recipients" do
      subject(:update_request) { patch admin_settings_job_application_file_type_path(job_application_file_type), params: }

      let(:params) do
        {
          job_application_file_type: {
            notify_user: true,
            notify_employer_recruiter: true,
            notify_employment_authority: false,
            notify_hr_manager: true,
            notify_payroll_manager: false
          }
        }
      end

      it "updates the notification recipients" do
        update_request
        job_application_file_type.reload
        expect(job_application_file_type.notify_user).to be(true)
        expect(job_application_file_type.notify_employer_recruiter).to be(true)
        expect(job_application_file_type.notify_employment_authority).to be(false)
        expect(job_application_file_type.notify_hr_manager).to be(true)
        expect(job_application_file_type.notify_payroll_manager).to be(false)
      end
    end

    context "when updating validation recipients" do
      subject(:update_request) { patch admin_settings_job_application_file_type_path(job_application_file_type), params: }

      let(:params) do
        {
          job_application_file_type: {
            validate_by_employer_recruiter: true,
            validate_by_employment_authority: false,
            validate_by_hr_manager: true,
            validate_by_payroll_manager: false
          }
        }
      end

      it "updates the validation recipients" do
        update_request
        job_application_file_type.reload
        expect(job_application_file_type.validate_by_employer_recruiter).to be(true)
        expect(job_application_file_type.validate_by_employment_authority).to be(false)
        expect(job_application_file_type.validate_by_hr_manager).to be(true)
        expect(job_application_file_type.validate_by_payroll_manager).to be(false)
      end
    end

    context "when destroying a visibility rule" do
      subject(:update_request) { patch admin_settings_job_application_file_type_path(job_application_file_type), params: }

      let!(:visibility_rule) {
        create(:visibility_rule, job_application_file_type: job_application_file_type, by: :administrator, state: :phone_meeting)
      }

      let(:params) do
        {
          job_application_file_type: {
            visibility_rules_attributes: [
              {id: visibility_rule.id, by: "administrator", state: visibility_rule.state, _destroy: "1"}
            ]
          }
        }
      end

      it "destroys the visibility rule" do
        expect { update_request }.to change { job_application_file_type.reload.visibility_rules.count }.by(-1)
        expect(response).to redirect_to(admin_settings_job_application_file_types_path)
      end
    end
  end
end
