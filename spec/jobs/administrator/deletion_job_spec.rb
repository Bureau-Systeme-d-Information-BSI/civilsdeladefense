require "rails_helper"

RSpec.describe Administrator::DeletionJob do
  subject(:perform) { described_class.new.perform }

  context "when the administrator was marked for deletion more than 30 days ago" do
    let!(:administrator) { create(:administrator, marked_for_deletion_at: 31.days.ago) }

    it { expect { perform }.to change { Administrator.exists?(administrator.id) }.to(false) }

    it { expect { perform }.to have_enqueued_mail(NotificationsMailer, :deletion_notice) }
  end

  context "when the administrator was marked for deletion within the last 30 days" do
    let!(:administrator) { create(:administrator, marked_for_deletion_at: 29.days.ago) }

    it { expect { perform }.not_to change { Administrator.exists?(administrator.id) } }
  end

  context "when the administrator is not marked for deletion" do
    let!(:administrator) { create(:administrator) }

    it { expect { perform }.not_to change { Administrator.exists?(administrator.id) } }
  end
end
