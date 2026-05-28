# frozen_string_literal: true

require "rails_helper"

RSpec.describe AltchaSolution do
  before { allow(Altcha).to receive(:hmac_key).and_return("test-hmac-key") }

  describe "validations" do
    it { is_expected.to validate_presence_of(:algorithm) }
    it { is_expected.to validate_presence_of(:challenge) }
    it { is_expected.to validate_presence_of(:salt) }
    it { is_expected.to validate_presence_of(:signature) }
    it { is_expected.to validate_presence_of(:number) }
  end

  describe ".verify_and_save" do
    subject(:verify_and_save) { described_class.verify_and_save(encoded) }

    context "with a valid submission" do
      let(:encoded) { encode(solution_params) }

      it { expect { verify_and_save }.to change(described_class, :count).by(1) }
      it { expect(verify_and_save).to be_truthy }
    end

    context "when the payload is not valid base64-encoded JSON" do
      let(:encoded) { Base64.encode64("definitely not json") }

      it { expect(verify_and_save).to be false }
    end

    context "when the signature is forged" do
      let(:encoded) { encode(solution_params.merge("signature" => "deadbeef")) }

      it { expect { verify_and_save }.not_to change(described_class, :count) }
      it { expect(verify_and_save).to be false }
    end

    context "when the challenge salt has expired" do
      let(:encoded) { encode(solution_params(salt_time: (Altcha.timeout + 1.minute).ago)) }

      it { expect(verify_and_save).to be false }
    end

    context "when replaying an already-saved solution" do
      let(:encoded) { encode(solution_params) }

      before { described_class.verify_and_save(encoded) }

      it { expect { verify_and_save }.not_to change(described_class, :count) }
      it { expect(verify_and_save).to be false }
    end
  end

  describe ".cleanup" do
    subject(:cleanup) { described_class.cleanup }

    let!(:old) { described_class.create!(solution_params(number: 111).merge("created_at" => (Altcha.timeout + 1.minute).ago)) }
    let!(:recent) { described_class.create!(solution_params(number: 222).merge("created_at" => 1.minute.ago)) }

    before { cleanup }

    it { expect(described_class.exists?(old.id)).to be false }
    it { expect(described_class.exists?(recent.id)).to be true }
  end

  private

  def solution_params(number: 123_456, salt_time: Time.zone.now)
    salt = [salt_time.to_s, SecureRandom.hex(12)].join("|")
    challenge = Digest::SHA256.hexdigest(salt + number.to_s)
    signature = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new(Altcha.algorithm), Altcha.hmac_key, challenge)
    {
      "algorithm" => Altcha.algorithm,
      "challenge" => challenge,
      "salt" => salt,
      "signature" => signature,
      "number" => number
    }
  end

  def encode(params)
    Base64.encode64(params.to_json)
  end
end

# == Schema Information
#
# Table name: altcha_solutions
#
#  id         :bigint           not null, primary key
#  algorithm  :string
#  challenge  :string
#  number     :integer
#  salt       :string
#  signature  :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_altcha_solutions  (algorithm,challenge,salt,signature,number) UNIQUE
#
