# frozen_string_literal: true

require "rails_helper"

RSpec.describe PdfUtils do
  describe ".convert_pdf_file_to_images" do
    subject(:convert) { described_class.convert_pdf_file_to_images(pdf_file) }

    let(:pdf_file) { instance_double(File, path: "document.pdf") }

    context "when the pdf can be opened" do
      let(:page) { instance_double(MiniMagick::Image, path: "page.pdf") }
      let(:image) { instance_double(MiniMagick::Image, pages: [page]) }

      before do
        allow(SecureRandom).to receive(:base36).and_return("abc123")
        allow(MiniMagick::Image).to receive(:open).with("document.pdf").and_return(image)
        allow(described_class).to receive(:convert_pdf_page_to_image)
        allow(Dir).to receive(:entries).with(".").and_return(["other.txt", "abc123-00000.png"])
      end

      it { is_expected.to eq(["abc123-00000.png"]) }
    end

    context "when ImageMagick fails to open the pdf" do
      before { allow(MiniMagick::Image).to receive(:open).and_raise("ImageMagick failure") }

      it { is_expected.to eq([]) }
    end
  end

  describe ".convert_pdf_page_to_image" do
    subject(:convert_page) { described_class.convert_pdf_page_to_image("prefix", "page.pdf", 2, 150) }

    let(:convert) { instance_double(MiniMagick::Tool::Convert) }

    before do
      allow(convert).to receive(:<<).and_return(convert)
      without_partial_double_verification do
        allow(MiniMagick::Tool::Convert).to receive(:new).and_yield(convert)
        convert_page
      end
    end

    it { expect(convert).to have_received(:<<).with("page.pdf") }

    it { expect(convert).to have_received(:<<).with("prefix-00002.png") }
  end

  describe ".convert_images_to_pdf" do
    subject(:convert_images) { described_class.convert_images_to_pdf(["a.png", "b.png"], "out.pdf") }

    let(:convert) { instance_double(MiniMagick::Tool::Convert) }

    before do
      allow(convert).to receive(:<<).and_return(convert)
      without_partial_double_verification do
        allow(MiniMagick::Tool::Convert).to receive(:new).and_yield(convert)
        convert_images
      end
    end

    it { expect(convert).to have_received(:<<).with("a.png") }

    it { expect(convert).to have_received(:<<).with("out.pdf") }
  end

  describe ".delete_files" do
    subject(:delete_files) { described_class.delete_files([existing_file, missing_file]) }

    let(:existing_file) { Rails.root.join("tmp/pdf_utils_spec_present.txt").to_s }
    let(:missing_file) { Rails.root.join("tmp/pdf_utils_spec_absent.txt").to_s }

    before { File.write(existing_file, "content") }

    after { File.delete(existing_file) if File.exist?(existing_file) }

    it { expect { delete_files }.to change { File.exist?(existing_file) }.from(true).to(false) }
  end
end
