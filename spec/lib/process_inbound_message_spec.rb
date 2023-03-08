# frozen_string_literal: true

require "rails_helper"

RSpec.describe ProcessInboundMessage do
  let!(:email) { create(:email) }
  let(:from) { create(:user).email }
  let(:to) { "rejoindre+#{email.id}@test.com" }
  let(:message_subject) { "A quote from Matz" }

  let(:message) do
    message = Mail.new(
      from: from,
      to: to,
      subject: message_subject,
      body: Faker::Quote.matz
    )
    message.add_file(Rails.root.join("spec/fixtures/files/document.pdf").to_s)
    message
  end

  before { Organization.first.update(inbound_email_config: :catch_all) }

  describe "call" do
    subject(:call) { described_class.new(message).call }

    shared_examples "an email creator" do
      it { is_expected.to be_truthy }

      it "create new email" do
        expect { call }.to(change(Email, :count))
      end

      it "create new email attachments" do
        expect { call }.to(change(EmailAttachment, :count))
      end
    end

    context "when all data are good" do
      it_behaves_like "an email creator"
    end

    context "when the message subject is nil" do
      let(:message_subject) { nil }

      it_behaves_like "an email creator"
    end

    context "when the message subject is empty" do
      let(:message_subject) { "" }

      it_behaves_like "an email creator"
    end

    context "when from is not a user email" do
      let(:from) { "not_a_user@test.com" }

      it_behaves_like "an email creator"

      it "create new email without sender" do
        expect { call }.to(change(Email, :count))
        expect(Email.order(:created_at).last.sender).to be_nil
      end
    end

    context "when to doesnt link to an existing email" do
      let(:to) { "rejoindre+wrong_email_id@test.com" }

      it { is_expected.to be_falsy }

      it "dont create new email for user" do
        expect { call }.not_to(change(Email, :count))
      end
    end

    context "when to has a weird formating" do
      let(:to) { "\"rejoindre+#{email.id}@test.com\" <rejoindre+#{email.id}@test.com>" }

      it_behaves_like "an email creator"
    end

    context "when to has a weird formating and multiple addresses" do
      let(:to) do
        [
          "other_email@test.com",
          "\"rejoindre+#{email.id}@test.com\" <rejoindre+#{email.id}@test.com>"
        ]
      end

      it_behaves_like "an email creator"
    end
  end
end
