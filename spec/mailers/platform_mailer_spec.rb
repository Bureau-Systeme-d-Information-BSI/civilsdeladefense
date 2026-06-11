# frozen_string_literal: true

require "rails_helper"

RSpec.describe PlatformMailer do
  let(:organization) { Organization.first }
  let(:service_name) { organization.service_name }

  describe "confirmation_instructions" do
    subject(:confirmation_instructions) { described_class.confirmation_instructions(record, "token-abc") }

    context "when the record is a candidate" do
      let(:record) { create(:user) }

      it { expect(confirmation_instructions.subject).to eq("[#{service_name}] Instructions de confirmation") }

      it { expect(confirmation_instructions.to).to eq([record.email]) }
    end

    context "when the record is an administrator" do
      let(:record) { create(:administrator) }

      it { expect(confirmation_instructions.subject).to eq("[#{service_name}] Instructions de confirmation") }

      it { expect(confirmation_instructions.body.encoded).to match(/Un compte a été créé sur le site de recrutement/) }
    end
  end

  describe "reset_password_instructions" do
    subject(:reset_password_instructions) { described_class.reset_password_instructions(record, "token-abc") }

    let(:record) { create(:user) }

    it { expect(reset_password_instructions.subject).to eq("[#{service_name}] Instructions pour changer le mot de passe") }

    it { expect(reset_password_instructions.to).to eq([record.email]) }
  end

  describe "unlock_instructions" do
    subject(:unlock_instructions) { described_class.unlock_instructions(record, "token-abc") }

    let(:record) { create(:user) }

    it { expect(unlock_instructions.subject).to eq("[#{service_name}] Instructions pour déverrouiller le compte") }

    it { expect(unlock_instructions.to).to eq([record.email]) }
  end

  describe "email_changed" do
    subject(:email_changed) { described_class.email_changed(record) }

    let(:record) { create(:user) }

    it { expect(email_changed.subject).to eq("[#{service_name}] Courriel modifié") }

    it { expect(email_changed.to).to eq([record.email]) }
  end

  describe "password_change" do
    subject(:password_change) { described_class.password_change(record) }

    let(:record) { create(:user) }

    it { expect(password_change.subject).to eq("[#{service_name}] Mot de passe modifié") }

    it { expect(password_change.to).to eq([record.email]) }
  end
end
