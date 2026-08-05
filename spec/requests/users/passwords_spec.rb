# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Users::Passwords" do
  describe "PUT /users/password" do
    subject(:reset_password_request) do
      put user_password_path, params: {
        user: {
          reset_password_token: token,
          password: "N3w-p4ssw0rd!aa",
          password_confirmation: "N3w-p4ssw0rd!aa"
        }
      }
    end

    let(:user) { create(:confirmed_user, marked_for_deletion_at: 3.days.ago) }
    let(:token) { user.send_reset_password_instructions }

    it { expect { reset_password_request }.to change { user.reload.marked_for_deletion_at }.to(nil) }

    it { expect { reset_password_request }.to have_enqueued_mail(ApplicantNotificationsMailer, :deletion_canceled) }
  end
end
