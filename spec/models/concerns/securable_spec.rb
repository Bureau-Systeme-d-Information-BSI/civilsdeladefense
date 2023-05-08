# frozen_string_literal: true

require "rails_helper"

RSpec.describe Securable, type: :model do
  describe "#document_content" do
    subject(:document_content) { securable.document_content }

    context "when the secured_content exists" do
      let(:securable) { build(:job_application_file, :secured) }

      it { is_expected.to eq(securable.secured_content) }
    end

    context "when the secured content doesn't exist" do
      context "when the content exists" do
        let(:securable) { build(:job_application_file) }

        it { is_expected.to eq(securable.content) }
      end

      context "when the content doesn't exist" do
        let(:securable) { build(:job_application_file, content: nil) }

        it { is_expected.to be_nil }
      end
    end
  end

  describe "#secured?" do
    subject(:secured?) { securable.secured? }

    context "when the securable file is secured" do
      let(:securable) { build(:job_application_file, :secured) }

      it { is_expected.to be(true) }
    end

    context "when the securable file is not secured" do
      let(:securable) { build(:job_application_file) }

      it { is_expected.to be(false) }
    end
  end

  describe "After commit" do
    subject(:commit) { securable.save }

    context "when the securable file is secured" do
      let(:securable) { build(:job_application_file, :secured) }

      it { expect { commit }.not_to have_enqueued_job { SecureContentJob } }
    end

    context "when the securable file is not secured" do
      let!(:securable) { build(:job_application_file) }

      it { expect { commit }.to have_enqueued_job { SecureContentJob }.with(securable.id) }
    end
  end
end
