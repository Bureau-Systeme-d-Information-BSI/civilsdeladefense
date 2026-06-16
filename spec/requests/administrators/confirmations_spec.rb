# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Administrators::Confirmations", type: :request do
  let(:token) { "confirmation-token" }

  describe "GET /admin/confirmation" do
    subject(:show_request) { get administrator_confirmation_path, params: {confirmation_token: token} }

    before do
      administrator
      show_request
    end

    context "when the confirmation token has expired" do
      let(:administrator) { unconfirmed_administrator(sent_at: 4.days.ago) }

      it { expect(response).to have_http_status(:ok) }
    end

    context "when the administrator has not set a password yet" do
      let(:administrator) { unconfirmed_administrator(with_password: false) }

      it { expect(response.body).to include("administrator[password]") }
    end

    context "when the administrator already has a password" do
      let(:administrator) { unconfirmed_administrator(with_password: true) }

      it { expect(response).to be_redirect }
    end

    context "when the confirmation token is unknown" do
      let(:token) { "unknown-token" }
      let(:administrator) { nil }

      it { expect(response).to have_http_status(:ok) }
    end
  end

  describe "PATCH /admin/confirmation" do
    subject(:update_request) { patch update_administrator_confirmation_path, params: }

    before do
      administrator
      update_request
    end

    context "when the administrator has no password and submits valid data" do
      let(:administrator) { unconfirmed_administrator(with_password: false) }
      let(:params) do
        {
          confirmation_token: token,
          administrator: {first_name: "Jane", last_name: "Doe", password: "Sup3rSecret!!", password_confirmation: "Sup3rSecret!!"}
        }
      end

      it { expect(response).to be_redirect }
    end

    context "when the administrator has no password and submits mismatched passwords" do
      let(:administrator) { unconfirmed_administrator(with_password: false) }
      let(:params) do
        {confirmation_token: token, administrator: {password: "Sup3rSecret!!", password_confirmation: "mismatch"}}
      end

      it { expect(response.body).to include("administrator[password]") }
    end

    context "when the administrator already has a password" do
      let(:administrator) { unconfirmed_administrator(with_password: true) }
      let(:params) do
        {confirmation_token: token, administrator: {password: "Sup3rSecret!!", password_confirmation: "Sup3rSecret!!"}}
      end

      it { expect(response.body).to include("Renvoyer") }
    end
  end

  private

  def unconfirmed_administrator(with_password: true, sent_at: Time.current)
    create(:administrator).tap do |admin|
      # rubocop:disable Rails/SkipsModelValidations
      admin.update_columns(
        confirmed_at: nil,
        confirmation_token: token,
        confirmation_sent_at: sent_at,
        encrypted_password: with_password ? admin.encrypted_password : ""
      )
      # rubocop:enable Rails/SkipsModelValidations
    end
  end
end
