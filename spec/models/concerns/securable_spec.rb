# frozen_string_literal: true

require "rails_helper"

RSpec.describe Securable do
  describe "#document_content" do
    subject(:document_content) { securable.document_content }

    context "when the secured_content exists" do
      let(:securable) { build(:job_application_file, :secured) }

      context "when DELIVER_SECURED_CONTENT is set" do
        before { stub_const "Securable::DELIVER_SECURED_CONTENT", "1" }

        it { is_expected.to eq(securable.secured_content) }
      end

      context "when DELIVER_SECURED_CONTENT is unset" do
        before { stub_const "Securable::DELIVER_SECURED_CONTENT", nil }

        it { is_expected.to eq(securable.content) }
      end
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
      let!(:securable) { build(:email_attachment, content: content) }

      context "when the content type is pdf" do
        before { allow(ENV).to receive(:fetch).with("SECURE_CONTENT", false).and_return("1") }

        let(:content) {
          Rack::Test::UploadedFile.new(Rails.root.join("spec/fixtures/files/document.pdf"), "application/pdf")
        }

        it do
          commit
          expect(SecureContentJob).to have_been_enqueued.with(id: securable.id)
        end
      end

      context "when the content type is not pdf" do
        let(:content) {
          Rack::Test::UploadedFile.new(Rails.root.join("spec/fixtures/files/user.jpg"), "image/jpeg")
        }

        it { expect { commit }.not_to have_enqueued_job { SecureContentJob } }
      end
    end
  end

  describe "#secure_content!" do
    subject(:secure_content!) { securable.secure_content! }

    context "when the file is already secured" do
      let(:securable) { build(:job_application_file, :secured) }

      before do
        allow(PdfUtils).to receive(:convert_images_to_pdf)
        secure_content!
      end

      it { expect(PdfUtils).not_to have_received(:convert_images_to_pdf) }
    end

    context "when the content is blank" do
      let(:securable) { build(:job_application_file, content: nil) }

      before do
        allow(PdfUtils).to receive(:convert_images_to_pdf)
        secure_content!
      end

      it { expect(PdfUtils).not_to have_received(:convert_images_to_pdf) }
    end

    context "when the content is not a pdf" do
      let(:securable) do
        build(
          :job_application_file,
          content: Rack::Test::UploadedFile.new(Rails.root.join("spec/fixtures/files/user.jpg"), "image/jpeg")
        )
      end

      before do
        allow(PdfUtils).to receive(:convert_images_to_pdf)
        secure_content!
      end

      it { expect(PdfUtils).not_to have_received(:convert_images_to_pdf) }
    end

    context "when the content type cannot be read" do
      let(:securable) { build(:job_application_file) }

      before do
        allow(securable.content).to receive(:content_type).and_raise(StandardError)
        allow(PdfUtils).to receive(:convert_images_to_pdf)
        secure_content!
      end

      it { expect(PdfUtils).not_to have_received(:convert_images_to_pdf) }
    end

    context "when the pdf produces no image" do
      let(:securable) { build(:job_application_file) }

      before do
        allow(PdfUtils).to receive(:convert_pdf_file_to_images).and_return([])
        allow(PdfUtils).to receive(:convert_images_to_pdf)
        secure_content!
      end

      it { expect(PdfUtils).not_to have_received(:convert_images_to_pdf) }
    end

    context "when the pdf is converted successfully" do
      let(:securable) { create(:job_application_file) }

      before do
        allow(PdfUtils).to receive(:convert_pdf_file_to_images).and_return(["page-00000.png"])
        allow(PdfUtils).to receive(:convert_images_to_pdf) { |_images, filename| FileUtils.cp(pdf_fixture, filename) }
      end

      it { expect { secure_content! }.to change(securable, :secured?).from(false).to(true) }
    end
  end

  private

  def pdf_fixture = Rails.root.join("spec/fixtures/files/document.pdf")
end
