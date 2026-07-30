# frozen_string_literal: true

require "rails_helper"

RSpec.describe Administrator::Deletable do
  describe ".long_time_unauthenticated" do
    subject(:long_time_unauthenticated) { Administrator.long_time_unauthenticated }

    context "when the administrator has not signed in for more than 12 months" do
      let!(:administrator) { create(:administrator, last_sign_in_at: 13.months.ago) }

      it { is_expected.to include(administrator) }
    end

    context "when the administrator has signed in within the last 12 months" do
      let!(:administrator) { create(:administrator, last_sign_in_at: 11.months.ago) }

      it { is_expected.not_to include(administrator) }
    end

    context "when the administrator has never signed in and was created more than 12 months ago" do
      let!(:administrator) { create(:administrator, last_sign_in_at: nil, created_at: 13.months.ago) }

      it { is_expected.to include(administrator) }
    end

    context "when the administrator has never signed in and was created within the last 12 months" do
      let!(:administrator) { create(:administrator, last_sign_in_at: nil, created_at: 11.months.ago) }

      it { is_expected.not_to include(administrator) }
    end

    context "when the administrator is already marked for deletion" do
      let!(:administrator) { create(:administrator, last_sign_in_at: 13.months.ago, marked_for_deletion_at: 3.days.ago) }

      it { is_expected.not_to include(administrator) }
    end
  end

  describe ".deletables" do
    subject(:deletables) { Administrator.deletables }

    context "when the administrator was marked for deletion more than 30 days ago" do
      let!(:administrator) { create(:administrator, marked_for_deletion_at: 31.days.ago) }

      it { is_expected.to include(administrator) }
    end

    context "when the administrator was marked for deletion within the last 30 days" do
      let!(:administrator) { create(:administrator, marked_for_deletion_at: 29.days.ago) }

      it { is_expected.not_to include(administrator) }
    end

    context "when the administrator is not marked for deletion" do
      let!(:administrator) { create(:administrator) }

      it { is_expected.not_to include(administrator) }
    end
  end

  describe "#mark_for_deletion!" do
    subject(:mark_for_deletion!) { administrator.mark_for_deletion! }

    let(:administrator) { create(:administrator) }

    it { expect { mark_for_deletion! }.to change { administrator.reload.marked_for_deletion_at }.from(nil) }

    it { expect { mark_for_deletion! }.to have_enqueued_mail(NotificationsMailer, :deletion_warning) }
  end

  describe "#destroy_and_notify!" do
    subject(:destroy_and_notify!) { administrator.destroy_and_notify! }

    let!(:administrator) { create(:administrator) }

    it { expect { destroy_and_notify! }.to change { Administrator.exists?(administrator.id) }.to(false) }

    it { expect { destroy_and_notify! }.to have_enqueued_mail(NotificationsMailer, :deletion_notice) }
  end

  describe "#cancel_deletion!" do
    subject(:cancel_deletion!) { administrator.cancel_deletion! }

    context "when the administrator is marked for deletion" do
      let(:administrator) { create(:administrator, marked_for_deletion_at: 3.days.ago) }

      it { expect { cancel_deletion! }.to change { administrator.reload.marked_for_deletion_at }.to(nil) }

      it { expect { cancel_deletion! }.to have_enqueued_mail(NotificationsMailer, :deletion_canceled) }
    end

    context "when the administrator is not marked for deletion" do
      let(:administrator) { create(:administrator) }

      it { expect { cancel_deletion! }.not_to have_enqueued_mail(NotificationsMailer, :deletion_canceled) }
    end
  end

  describe "#after_database_authentication" do
    subject(:after_database_authentication) { administrator.after_database_authentication }

    context "when the administrator is marked for deletion" do
      let(:administrator) { create(:administrator, marked_for_deletion_at: 3.days.ago) }

      it { expect { after_database_authentication }.to change { administrator.reload.marked_for_deletion_at }.to(nil) }

      it { expect { after_database_authentication }.to have_enqueued_mail(NotificationsMailer, :deletion_canceled) }
    end

    context "when the administrator is not marked for deletion" do
      let(:administrator) { create(:administrator) }

      it { expect { after_database_authentication }.not_to have_enqueued_mail(NotificationsMailer, :deletion_canceled) }
    end
  end

  describe "#reset_password" do
    subject(:reset_password) { administrator.reset_password(new_password, new_password) }

    let(:administrator) { create(:administrator, marked_for_deletion_at: 3.days.ago) }

    context "when the new password is valid" do
      let(:new_password) { "N3w-p4ssw0rd!aa" }

      it { expect { reset_password }.to change { administrator.reload.marked_for_deletion_at }.to(nil) }

      it { expect { reset_password }.to have_enqueued_mail(NotificationsMailer, :deletion_canceled) }
    end

    context "when the new password is invalid" do
      let(:new_password) { "weak" }

      it { expect { reset_password }.not_to change { administrator.reload.marked_for_deletion_at } }

      it { expect { reset_password }.not_to have_enqueued_mail(NotificationsMailer, :deletion_canceled) }
    end
  end
end
