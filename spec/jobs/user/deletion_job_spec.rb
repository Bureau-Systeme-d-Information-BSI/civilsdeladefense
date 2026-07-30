require "rails_helper"

RSpec.describe User::DeletionJob do
  subject(:perform) { described_class.new.perform }

  context "when the user was marked for deletion more than 30 days ago" do
    let!(:user) { create(:user, marked_for_deletion_at: 31.days.ago) }

    it { expect { perform }.to change { User.exists?(user.id) }.to(false) }

    it { expect { perform }.to have_enqueued_mail(ApplicantNotificationsMailer, :deletion_notice) }
  end

  context "when the user was marked for deletion within the last 30 days" do
    let!(:user) { create(:user, marked_for_deletion_at: 29.days.ago) }

    it { expect { perform }.not_to change { User.exists?(user.id) } }
  end

  context "when the user is not marked for deletion" do
    let!(:user) { create(:user) }

    it { expect { perform }.not_to change { User.exists?(user.id) } }
  end
end
