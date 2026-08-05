# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Users::Sessions" do
  describe "POST /users/sign_in" do
    subject(:sign_in_request) do
      post user_session_path, params: {user: {email: user.email, password: user.password}}
    end

    context "when the user is marked for deletion" do
      let(:user) { create(:confirmed_user, marked_for_deletion_at: 3.days.ago) }

      it { expect { sign_in_request }.to change { user.reload.marked_for_deletion_at }.to(nil) }

      it { expect { sign_in_request }.to have_enqueued_mail(ApplicantNotificationsMailer, :deletion_canceled) }
    end

    context "when the user is not marked for deletion" do
      let(:user) { create(:confirmed_user) }

      it { expect { sign_in_request }.not_to change { user.reload.marked_for_deletion_at } }

      it { expect { sign_in_request }.not_to have_enqueued_mail(ApplicantNotificationsMailer, :deletion_canceled) }
    end
  end
end
