require "rails_helper"

RSpec.describe User::MarkForDeletionJob do
  subject(:perform) { described_class.new.perform }

  context "when the user has not signed in for more than 12 months" do
    let!(:user) { create(:user, last_sign_in_at: 13.months.ago) }

    it { expect { perform }.to change { user.reload.marked_for_deletion_at }.from(nil) }
  end

  context "when the user has signed in within the last 12 months" do
    let!(:user) { create(:user, last_sign_in_at: 11.months.ago) }

    it { expect { perform }.not_to change { user.reload.marked_for_deletion_at } }
  end
end
