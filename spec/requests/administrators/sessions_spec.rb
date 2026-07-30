# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Administrators::Sessions" do
  describe "POST /admin/sign_in" do
    subject(:sign_in_request) do
      post administrator_session_path, params: {administrator: {email: administrator.email, password: administrator.password}}
    end

    context "when the administrator is marked for deletion" do
      let(:administrator) { create(:administrator, marked_for_deletion_at: 3.days.ago) }

      it { expect { sign_in_request }.to change { administrator.reload.marked_for_deletion_at }.to(nil) }

      it { expect { sign_in_request }.to have_enqueued_mail(NotificationsMailer, :deletion_canceled) }
    end

    context "when the administrator is not marked for deletion" do
      let(:administrator) { create(:administrator) }

      it { expect { sign_in_request }.not_to change { administrator.reload.marked_for_deletion_at } }

      it { expect { sign_in_request }.not_to have_enqueued_mail(NotificationsMailer, :deletion_canceled) }
    end
  end
end
