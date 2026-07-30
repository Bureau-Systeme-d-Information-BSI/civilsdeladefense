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

  describe "#mark_for_deletion!" do
    subject(:mark_for_deletion!) { user.mark_for_deletion! }

    let(:user) { create(:user) }

    it { expect { mark_for_deletion! }.to change { user.reload.marked_for_deletion_at }.from(nil) }

    it { expect { mark_for_deletion! }.to have_enqueued_mail(ApplicantNotificationsMailer, :deletion_warning) }
  end
end
