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

  describe "#blank_photo" do
    subject(:blank_photo) { helper.blank_photo }

    it { is_expected.to include("default_user_avatar") }
  end

  describe "#image_user_tag" do
    subject(:image_user_tag) { helper.image_user_tag(nil, options) }

    context "without options" do
      let(:options) { nil }

      it { is_expected.to include(%(class="rounded-circle w- h-")) }
    end

    context "when a class array is given" do
      let(:options) { {width: 50, class: ["foo"]} }

      it { is_expected.to include(%(class="rounded-circle w-50 h-50 foo")) }
    end

    context "when a single class is given" do
      let(:options) { {height: 30, class: "bar"} }

      it { is_expected.to include(%(class="rounded-circle w-30 h-30 bar")) }
    end
  end

  describe "#image_user_url" do
    subject(:image_user_url) { helper.image_user_url(photo) }

    context "when the photo is blank" do
      let(:photo) { nil }

      it { is_expected.to include("default_user_avatar") }
    end

    context "when the current user has a photo" do
      let(:photo) { double(blank?: false) }

      before { allow(helper).to receive(:current_user).and_return(double(photo: "present")) }

      it { is_expected.to eq("/espace-candidat/mon-compte/photo") }
    end

    context "when an administrator views a user photo" do
      let(:user) { create(:user) }
      let(:photo) { double(blank?: false, model: user) }

      before { allow(helper).to receive_messages(current_user: nil, current_administrator: double) }

      it { is_expected.to eq("/admin/candidats/#{user.id}/photo") }
    end

    context "when an administrator views an administrator photo" do
      let(:administrator) { create(:administrator) }
      let(:photo) { double(blank?: false, model: administrator) }

      before { allow(helper).to receive_messages(current_user: nil, current_administrator: double) }

      it { is_expected.to eq("/admin/account/photo?id=#{administrator.id}") }
    end

    context "when no rule matches" do
      let(:photo) { double(blank?: false) }

      before { allow(helper).to receive_messages(current_user: nil, current_administrator: nil) }

      it { is_expected.to include("default_user_avatar") }
    end

    context "when resolving the photo raises an error" do
      let(:photo) { Object.new }

      before { allow(helper).to receive_messages(current_user: nil, current_administrator: double) }

      it { is_expected.to include("default_user_avatar") }
    end
  end
end
