# frozen_string_literal: true

require "rails_helper"

RSpec.describe UsersHelper do
  describe "#file_hint" do
    subject(:hint) { helper.file_hint(job_application_file) }

    let(:job_application) { create(:job_application) }
    let(:job_application_file_type) { create(:job_application_file_type, kind:) }
    let(:job_application_file) do
      create(:job_application_file, job_application:, job_application_file_type:, is_validated:)
    end

    context "when the file type is applicant_provided" do
      let(:kind) { :applicant_provided }

      context "when the file is validated" do
        let(:is_validated) { 1 }

        it { is_expected.to include("a été validé") }
        it { is_expected.to include("valid-text") }
      end

      context "when the file is invalidated" do
        let(:is_validated) { 2 }

        it { is_expected.to include("n'est pas valide") }
        it { is_expected.to include("error-text") }
      end

      context "when the file is pending validation and has uploaded content" do
        let(:is_validated) { 0 }

        it { is_expected.to include("Vous avez déjà téléversé") }
        it { is_expected.to include("en attente de validation") }
      end

      context "when the file is pending validation but has no uploaded content" do
        let(:is_validated) { 0 }
        let(:job_application_file) do
          create(
            :job_application_file,
            job_application:,
            job_application_file_type:,
            content: nil,
            do_not_provide_immediately: true
          )
        end

        it { is_expected.to be_nil }
      end
    end

    context "when the file type is not applicant_provided" do
      let(:kind) { :employer_provided }
      let(:is_validated) { 0 }

      it { is_expected.to include("a été téléversé par un tiers") }
    end
  end
end
