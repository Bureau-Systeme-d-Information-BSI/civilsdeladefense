require "rails_helper"

RSpec.describe JobApplicationFile::Validatable do
  describe "#mark_as_valid!" do
    subject(:mark_as_valid) { job_application_file.mark_as_valid!(administrator) }

    let(:job_application_file) { create(:job_application_file, job_application:) }
    let(:job_application) { create(:job_application) }

    context "when administrator is authorized" do
      let(:administrator) { build(:administrator, roles: [:employer_recruiter]) }

      it { expect { mark_as_valid }.to change { job_application_file.reload.validated? }.to(true) }
    end

    context "when administrator is not authorized" do
      let(:administrator) { build(:administrator, roles: [:payroll_manager]) }

      it { expect(mark_as_valid).to be(false) }

      it { expect { mark_as_valid }.not_to change { job_application_file.reload.is_validated } }

      it "adds an error on base" do
        mark_as_valid
        expect(job_application_file.errors[:base]).to be_present
      end
    end
  end

  describe "#mark_as_invalid!" do
    subject(:mark_as_invalid) { job_application_file.mark_as_invalid!(administrator) }

    let(:job_application_file) { create(:job_application_file, job_application:) }
    let(:job_application) { create(:job_application) }

    before { job_application_file.update_column(:is_validated, 1) } # rubocop:disable Rails/SkipsModelValidations

    context "when administrator is authorized" do
      let(:administrator) { build(:administrator, roles: [:employer_recruiter]) }

      it { expect { mark_as_invalid }.to change { job_application_file.reload.rejected? }.to(true) }
    end

    context "when administrator is not authorized" do
      let(:administrator) { build(:administrator, roles: [:payroll_manager]) }

      it { expect(mark_as_invalid).to be(false) }

      it { expect { mark_as_invalid }.not_to change { job_application_file.reload.is_validated } }

      it "adds an error on base" do
        mark_as_invalid
        expect(job_application_file.errors[:base]).to be_present
      end
    end
  end

  describe "#validated?" do
    subject { job_application_file.validated? }

    let(:job_application_file) { build(:job_application_file, is_validated:) }

    context "when is_validated is 1" do
      let(:is_validated) { 1 }

      it { is_expected.to be(true) }
    end

    context "when is_validated is 0" do
      let(:is_validated) { 0 }

      it { is_expected.to be(false) }
    end

    context "when is_validated is 2" do
      let(:is_validated) { 2 }

      it { is_expected.to be(false) }
    end
  end

  describe "#rejected?" do
    subject { job_application_file.rejected? }

    let(:job_application_file) { build(:job_application_file, is_validated:) }

    context "when is_validated is 2" do
      let(:is_validated) { 2 }

      it { is_expected.to be(true) }
    end

    context "when is_validated is 0" do
      let(:is_validated) { 0 }

      it { is_expected.to be(false) }
    end

    context "when is_validated is 1" do
      let(:is_validated) { 1 }

      it { is_expected.to be(false) }
    end
  end

  describe "#waiting_validation?" do
    subject { job_application_file.waiting_validation? }

    let(:job_application_file) { build(:job_application_file, is_validated:) }

    context "when is_validated is 0" do
      let(:is_validated) { 0 }

      it { is_expected.to be(true) }
    end

    context "when is_validated is 1" do
      let(:is_validated) { 1 }

      it { is_expected.to be(false) }
    end

    context "when is_validated is 2" do
      let(:is_validated) { 2 }

      it { is_expected.to be(false) }
    end
  end
end
