# frozen_string_literal: true

require "rails_helper"

RSpec.describe User::Deletable do
  describe ".long_time_unauthenticated" do
    subject(:long_time_unauthenticated) { User.long_time_unauthenticated }

    context "when the user has not signed in for more than 12 months" do
      let!(:user) { create(:user, last_sign_in_at: 13.months.ago) }

      it { is_expected.to include(user) }
    end

    context "when the user has signed in within the last 12 months" do
      let!(:user) { create(:user, last_sign_in_at: 11.months.ago) }

      it { is_expected.not_to include(user) }
    end

    context "when the user has never signed in and was created more than 12 months ago" do
      let!(:user) { create(:user, last_sign_in_at: nil, created_at: 13.months.ago) }

      it { is_expected.to include(user) }
    end

    context "when the user has never signed in and was created within the last 12 months" do
      let!(:user) { create(:user, last_sign_in_at: nil, created_at: 11.months.ago) }

      it { is_expected.not_to include(user) }
    end

    context "when the user is already marked for deletion" do
      let!(:user) { create(:user, last_sign_in_at: 13.months.ago, marked_for_deletion_at: 3.days.ago) }

      it { is_expected.not_to include(user) }
    end

    context "when the user is suspended" do
      let!(:user) { create(:user, last_sign_in_at: 13.months.ago, suspended_at: 1.day.ago) }

      it { is_expected.not_to include(user) }
    end
  end

  describe ".deletables" do
    subject(:deletables) { User.deletables }

    context "when the user was marked for deletion more than 30 days ago" do
      let!(:user) { create(:user, marked_for_deletion_at: 31.days.ago) }

      it { is_expected.to include(user) }
    end

    context "when the user was marked for deletion within the last 30 days" do
      let!(:user) { create(:user, marked_for_deletion_at: 29.days.ago) }

      it { is_expected.not_to include(user) }
    end

    context "when the user is not marked for deletion" do
      let!(:user) { create(:user) }

      it { is_expected.not_to include(user) }
    end

    context "when the user was marked for deletion more than 30 days ago then suspended" do
      let!(:user) { create(:user, marked_for_deletion_at: 31.days.ago, suspended_at: 1.day.ago) }

      it { is_expected.not_to include(user) }
    end
  end

  describe "#mark_for_deletion!" do
    subject(:mark_for_deletion!) { user.mark_for_deletion! }

    let(:user) { create(:user) }

    it { expect { mark_for_deletion! }.to change { user.reload.marked_for_deletion_at }.from(nil) }

    it { expect { mark_for_deletion! }.to have_enqueued_mail(ApplicantNotificationsMailer, :deletion_warning) }
  end

  describe "#cancel_deletion!" do
    subject(:cancel_deletion!) { user.cancel_deletion! }

    context "when the user is marked for deletion" do
      let(:user) { create(:user, marked_for_deletion_at: 3.days.ago) }

      it { expect { cancel_deletion! }.to change { user.reload.marked_for_deletion_at }.to(nil) }

      it { expect { cancel_deletion! }.to have_enqueued_mail(ApplicantNotificationsMailer, :deletion_canceled) }
    end

    context "when the user is not marked for deletion" do
      let(:user) { create(:user) }

      it { expect { cancel_deletion! }.not_to have_enqueued_mail(ApplicantNotificationsMailer, :deletion_canceled) }
    end
  end

  describe "#after_database_authentication" do
    subject(:after_database_authentication) { user.after_database_authentication }

    let(:user) { create(:user, marked_for_deletion_at: 3.days.ago) }

    it { expect { after_database_authentication }.to change { user.reload.marked_for_deletion_at }.to(nil) }

    it { expect { after_database_authentication }.to have_enqueued_mail(ApplicantNotificationsMailer, :deletion_canceled) }
  end

  describe "#reset_password" do
    subject(:reset_password) { user.reset_password(new_password, new_password) }

    let(:user) { create(:user, marked_for_deletion_at: 3.days.ago) }

    context "when the new password is valid" do
      let(:new_password) { "N3w-p4ssw0rd!aa" }

      it { expect { reset_password }.to change { user.reload.marked_for_deletion_at }.to(nil) }

      it { expect { reset_password }.to have_enqueued_mail(ApplicantNotificationsMailer, :deletion_canceled) }
    end

    context "when the new password is invalid" do
      let(:new_password) { "weak" }

      it { expect { reset_password }.not_to change { user.reload.marked_for_deletion_at } }

      it { expect { reset_password }.not_to have_enqueued_mail(ApplicantNotificationsMailer, :deletion_canceled) }
    end
  end

  describe "#destroy_and_notify!" do
    subject(:destroy_and_notify!) { user.destroy_and_notify! }

    let!(:user) { create(:user) }

    it { expect { destroy_and_notify! }.to change { User.exists?(user.id) }.to(false) }

    it { expect { destroy_and_notify! }.to have_enqueued_mail(ApplicantNotificationsMailer, :deletion_notice) }

    context "with a job application" do
      before { create(:job_application, :with_job_application_file, user:) }

      it { expect { destroy_and_notify! }.to change(JobApplicationFile, :count).from(1).to(0) }
    end
  end
end
