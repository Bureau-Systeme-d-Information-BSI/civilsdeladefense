# frozen_string_literal: true

require "rails_helper"

RSpec.describe ProcessInboundMessage do
  let!(:email) { create(:email) }
  let(:user) { create(:user) }
  let(:from) { user.email }
  let(:to) { "rejoindre+#{email.id}@test.com" }

  let(:message) do
    Mail.new(from: from, to: to, subject: "A quote from Matz", body: Faker::Quote.matz)
  end

  describe "call" do
    let(:result) { ProcessInboundMessage.new(message).call }

    context "when inbound_email_config is catch_all" do
      before do
        Organization.first.update(inbound_email_config: :catch_all)
      end

      context "when all data are good" do
        it("true") do
          expect(result).to be_truthy
        end

        it "create new email for user" do
          expect { result }.to(change { Email.count })
        end
      end

      context "when from is not a user email" do
        let(:from) { "not_a_user@test.com" }

        it("true") do
          expect(result).to be_truthy
        end

        it "create new email without sender" do
          expect { result }.to(change { Email.count })
          expect(Email.order(:created_at).last.sender).to be(nil)
        end
      end

      context "when to doesnt link to an existing email" do
        let(:to) { "rejoindre+wrong_email_id@test.com" }

        it("false") do
          expect(result).to be_falsy
        end

        it "dont create new email for user" do
          expect { result }.to_not(change { Email.count })
        end
      end

      context "when to has a weird formating" do
        let(:to) { "\"rejoindre+#{email.id}@test.com\" <rejoindre+#{email.id}@test.com>" }

        it("true") do
          expect(result).to be_truthy
        end

        it "create new email for user" do
          expect { result }.to(change { Email.count })
        end
      end

      context "when to has a weird formating and multiple addresses" do
        let(:to) do
          [
            "other_email@test.com",
            "\"rejoindre+#{email.id}@test.com\" <rejoindre+#{email.id}@test.com>"
          ]
        end

        it("true") do
          expect(result).to be_truthy
        end

        it "create new email for user" do
          expect { result }.to(change { Email.count })
        end
      end
    end
  end
end
