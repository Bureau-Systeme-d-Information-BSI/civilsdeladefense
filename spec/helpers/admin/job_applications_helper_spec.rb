# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::JobApplicationsHelper do
  describe "#requestable_file_types" do
    subject(:requestable_file_types) { helper.requestable_file_types(job_application, administrator) }

    let(:job_application) { create(:job_application, state: :to_be_met) }
    let!(:manager_file_type) do
      create(:job_application_file_type, kind: :manager_provided).tap do |jaft|
        jaft.visibility_rules.where(by: :administrator).destroy_all
        jaft.visibility_rules.create!(by: :administrator, state: :phone_meeting)
      end
    end
    let!(:employer_file_type) do
      create(:job_application_file_type, kind: :employer_provided).tap do |jaft|
        jaft.visibility_rules.where(by: :administrator).destroy_all
        jaft.visibility_rules.create!(by: :administrator, state: :phone_meeting)
      end
    end

    context "when administrator is neither a hr_manager nor a payroll_manager" do
      let(:administrator) { build(:administrator, roles: %w[functional_administrator]) }

      it { is_expected.to contain_exactly(manager_file_type, employer_file_type) }

      context "when a file has already been requested" do
        before { create(:job_application_file, job_application:, job_application_file_type: manager_file_type) }

        it { is_expected.to contain_exactly(employer_file_type) }
      end
    end

    context "when administrator is a hr_manager" do
      let(:administrator) { build(:administrator, roles: %w[hr_manager]) }

      it { is_expected.to contain_exactly(manager_file_type) }
    end

    context "when administrator is a payroll_manager" do
      let(:administrator) { build(:administrator, roles: %w[payroll_manager]) }

      it { is_expected.to contain_exactly(manager_file_type) }
    end
  end

  describe "#job_application_resume_url" do
    subject(:resume_url) { helper.job_application_resume_url(job_application) }

    context "when job_application is nil" do
      let(:job_application) { nil }

      it { is_expected.to be_nil }
    end

    context "when job_application has a file with visible_by_user file type" do
      let(:job_application) { create(:job_application) }
      let(:job_application_file_type) { create(:job_application_file_type) }

      before { create(:job_application_file, job_application:, job_application_file_type:) }

      it { is_expected.to be_present }
    end

    context "when job_application has no matching file" do
      let(:job_application) { create(:job_application) }

      it { is_expected.to be_nil }
    end

    context "when job_application has a file but file type is not visible by user at initial state" do
      let(:job_application) { create(:job_application) }
      let(:job_application_file_type) { create(:job_application_file_type, kind: :employer_provided) }

      before { create(:job_application_file, job_application:, job_application_file_type:) }

      it { is_expected.to be_nil }
    end
  end

  describe "#change_state_options" do
    subject(:change_state_options) { helper.change_state_options(job_application, administrator) }

    let(:job_application) { build(:job_application, state:) }
    let(:administrator) { build(:administrator, roles:) }

    context "when the administrator can transition to several states" do
      let(:roles) { [:functional_administrator] }
      let(:state) { :initial }

      it "includes the current state and every allowed target state" do
        expect(change_state_options.map(&:last)).to contain_exactly(:initial, :phone_meeting, :to_be_met, :financial_estimate)
      end

      it "translates each option label" do
        expect(change_state_options.map(&:first)).to all(be_a(String).and(be_present))
      end
    end

    context "when the administrator has no allowed transition from the current state" do
      let(:roles) { [:hr_manager] }
      let(:state) { :initial }

      it "returns only the current state" do
        expect(change_state_options.map(&:last)).to contain_exactly(:initial)
      end
    end
  end

  describe "#can_change_state?" do
    subject(:can_change_state?) { helper.can_change_state?(job_application, administrator) }

    let(:job_application) { build(:job_application, state: state) }
    let(:administrator) { build(:administrator, roles: roles) }

    context "when the administrator has at least one allowed transition" do
      let(:roles) { [:functional_administrator] }
      let(:state) { :initial }

      it { is_expected.to be(true) }
    end

    context "when the administrator has no allowed transition from the current state" do
      let(:roles) { [:hr_manager] }
      let(:state) { :initial }

      it { is_expected.to be(false) }
    end
  end

  describe "#job_application_modal_section_classes" do
    subject(:job_application_modal_section_classes) { helper.job_application_modal_section_classes(additional_class) }

    context "when the additional class is pb-0" do
      let(:additional_class) { "pb-0" }

      it { is_expected.to eq(%w[px-4 pt-4 pb-0]) }
    end

    context "when no additional class is given" do
      let(:additional_class) { nil }

      it { is_expected.to eq(%w[px-4 py-4]) }
    end
  end

  describe "#job_applications_tab_active" do
    subject(:job_applications_tab_active) { helper.job_applications_tab_active }

    before { allow(controller).to receive_messages(controller_name:, action_name:) }

    context "when the controller is not job_applications" do
      let(:controller_name) { "job_offers" }
      let(:action_name) { "index" }

      it { is_expected.to be_nil }
    end

    context "when on the show action" do
      let(:controller_name) { "job_applications" }
      let(:action_name) { "show" }

      it { is_expected.to eq(:profile) }
    end

    context "when on the cvlm action" do
      let(:controller_name) { "job_applications" }
      let(:action_name) { "cvlm" }

      it { is_expected.to eq(:cvlm) }
    end

    context "when on the emails action" do
      let(:controller_name) { "job_applications" }
      let(:action_name) { "emails" }

      it { is_expected.to eq(:emails) }
    end

    context "when on the files action" do
      let(:controller_name) { "job_applications" }
      let(:action_name) { "files" }

      it { is_expected.to eq(:files) }
    end
  end

  describe "#in_place_edit_value_formatted" do
    subject(:in_place_edit_value_formatted) { helper.in_place_edit_value_formatted(content, field) }

    context "when the field is availability_date_in_month" do
      let(:content) { "6" }
      let(:field) { :availability_date_in_month }

      it { is_expected.to eq("6 mois") }
    end

    context "when the field is a gender" do
      let(:content) { "male" }
      let(:field) { :gender }

      it { is_expected.to eq("Homme") }
    end

    context "when the field is anything else" do
      let(:content) { "free text" }
      let(:field) { :other }

      it { is_expected.to eq("free text") }
    end
  end

  describe "#in_place_edit_value" do
    subject(:in_place_edit_value) { helper.in_place_edit_value(obj, opts) }

    context "when a field option is given" do
      let(:obj) { double(full_name: "John Doe") }
      let(:opts) { {field: :full_name} }

      it { is_expected.to eq("John Doe") }
    end

    context "when an association option is given" do
      let(:obj) { double(category: double(name: "Defense")) }
      let(:opts) { {association: :category} }

      it { is_expected.to eq("Defense") }
    end

    context "when the resolved value is blank" do
      let(:obj) { double(full_name: "") }
      let(:opts) { {field: :full_name} }

      it { is_expected.to eq("<em>Non défini(e)</em>") }
    end
  end

  describe "#choices_boolean" do
    subject(:choices_boolean) { helper.choices_boolean }

    it { is_expected.to eq([["En poste", true], ["Disponible immédiatement", false]]) }
  end

  describe "#choices_gender" do
    subject(:choices_gender) { helper.choices_gender }

    it { is_expected.to eq([["Femme", "female"], ["Homme", "male"], ["Autre", "other"]]) }
  end
end
