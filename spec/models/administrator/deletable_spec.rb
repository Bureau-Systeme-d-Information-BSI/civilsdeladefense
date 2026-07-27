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

  describe "#mark_for_deletion!" do
    subject(:mark_for_deletion!) { administrator.mark_for_deletion! }

    let(:administrator) { create(:administrator) }

    it { expect { mark_for_deletion! }.to change { administrator.reload.marked_for_deletion_at }.from(nil) }

    it { expect { mark_for_deletion! }.to have_enqueued_mail(NotificationsMailer, :deletion_warning) }
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
end
