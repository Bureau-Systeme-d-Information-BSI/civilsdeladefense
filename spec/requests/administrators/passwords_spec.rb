# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Administrators::Passwords" do
  describe "PUT /admin/password" do
    subject(:reset_password_request) do
      put administrator_password_path, params: {
        administrator: {
          reset_password_token: token,
          password: "N3w-p4ssw0rd!aa",
          password_confirmation: "N3w-p4ssw0rd!aa"
        }
      }
    end

    let(:administrator) { create(:administrator, marked_for_deletion_at: 3.days.ago) }
    let(:token) { administrator.send_reset_password_instructions }

    it { expect { reset_password_request }.to change { administrator.reload.marked_for_deletion_at }.to(nil) }

    it { expect { reset_password_request }.to have_enqueued_mail(NotificationsMailer, :deletion_canceled) }
  end
end
