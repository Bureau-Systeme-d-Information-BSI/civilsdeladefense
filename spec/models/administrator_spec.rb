# frozen_string_literal: true

require "rails_helper"

RSpec.describe Administrator do
  let(:administrator) { create(:administrator) }

  describe "associations" do
    it { is_expected.to have_many(:invitees).inverse_of(:inviter) }

    it { is_expected.to have_many(:owned_job_offers).inverse_of(:owner) }

    it { is_expected.to have_many(:administrator_employers).dependent(:destroy) }

    it { is_expected.to have_many(:employers).through(:administrator_employers) }
  end

  describe "validations" do
    it { expect(administrator).to be_valid }

    it { is_expected.to validate_presence_of(:first_name) }

    it { is_expected.to validate_presence_of(:last_name) }

    it { is_expected.to validate_presence_of(:title) }

    it { is_expected.to validate_presence_of(:roles) }

    describe "roles_inclusion" do
      subject { administrator.valid? }

      let(:administrator) { build(:administrator) }

      context "when roles are empty" do
        before { administrator.roles = [] }

        it { is_expected.to be_falsey }
      end

      context "when roles are invalid" do
        before { administrator.roles = ["invalid_role"] }

        it { is_expected.to be_falsey }
      end

      context "when roles are valid" do
        before { administrator.roles = ["functional_administrator", "hr_manager"] }

        it { is_expected.to be_truthy }
      end
    end
  end

  describe "before_validation callbacks" do
    describe "#set_first_name" do
      subject(:save) { administrator.save! }

      let(:administrator) { build(:administrator, first_name: nil, email: "john.doe@example.com") }

      it { expect { save }.to change(administrator, :first_name).from(nil).to("John") }
    end

    describe "#set_last_name" do
      subject(:save) { administrator.save! }

      let(:administrator) { build(:administrator, last_name: nil, email: "john.doe@example.com") }

      it { expect { save }.to change(administrator, :last_name).from(nil).to("Doe") }
    end

    describe "#set_title" do
      subject(:save) { administrator.save! }

      let(:administrator) { build(:administrator, title: nil) }

      it { expect { save }.to change(administrator, :title).from(nil).to("-") }
    end
  end

  it "has a unique email" do
    administrator2 = build(:administrator, email: administrator.email)
    expect(administrator2).not_to be_valid
  end

  it "lock the administrator after 10 wrong authentication attempts" do
    1.upto(9) do |i|
      administrator.valid_for_authentication? { false }
      expect(administrator.failed_attempts).to eq(i)
      expect(administrator.locked_at).to be_nil
    end

    administrator.valid_for_authentication? { false }
    expect(administrator.failed_attempts).to eq(10)
    expect(administrator.locked_at).not_to be_nil
  end

  it "check correctly the confirmation token validity duration" do
    expect(administrator).to be_confirmation_token_still_valid

    administrator2 = build(:administrator, confirmed_at: nil, confirmation_sent_at: 4.days.ago)
    expect(administrator2).not_to be_confirmation_token_still_valid
  end

  it "creates provided supervisor administrator when non-preexisting" do
    administrator = build(:administrator)
    employer = create(:employer)

    attrs = {
      first_name: "Supervisor",
      last_name: "Supervisor",
      email: "supervisor@gmail.com",
      roles: [:employer_recruiter],
      ensure_employer_is_set: true,
      employer_id: employer.id
    }

    expect {
      administrator.supervisor_administrator_attributes = attrs
      administrator.save!
    }.to change(described_class, :count).by(2)

    expect(administrator.supervisor_administrator.email).to eq("supervisor@gmail.com")
  end

  it "creates provided supervisor administrator when preexisting" do
    employer = create(:employer)
    supervisor_administrator = create(:administrator, employer: employer)
    administrator = build(:administrator)

    attrs = {
      first_name: "Supervisor",
      last_name: "Supervisor",
      email: supervisor_administrator.email,
      roles: [:employer_recruiter],
      ensure_employer_is_set: true,
      employer_id: employer.id
    }

    expect {
      administrator.supervisor_administrator_attributes = attrs
      administrator.save!
    }.to change(described_class, :count).by(1)

    expect(administrator.supervisor_administrator.email).to eq(supervisor_administrator.email)
  end

  it "creates provided grand employer administrator when non-preexisting" do
    administrator = build(:administrator)
    employer = create(:employer)

    attrs = {
      first_name: "Grand Employer",
      last_name: "Grand Employer",
      email: "grand.employer@gmail.com",
      roles: [:employer_recruiter],
      ensure_employer_is_set: true,
      employer_id: employer.id
    }

    expect {
      administrator.grand_employer_administrator_attributes = attrs
      administrator.save!
    }.to change(described_class, :count).by(2)

    expect(administrator.grand_employer_administrator.email).to eq("grand.employer@gmail.com")
  end

  it "creates provided grand employer administrator when preexisting" do
    employer = create(:employer)
    grand_employer_administrator = create(:administrator, employer: employer)
    email = grand_employer_administrator.email
    administrator = build(:administrator)

    attrs = {
      email: email,
      ensure_employer_is_set: true,
      employer_id: employer.id
    }

    expect {
      administrator.grand_employer_administrator_attributes = attrs
      administrator.save
    }.to change(described_class, :count).by(1)

    expect(administrator.grand_employer_administrator.email).to eq(email)
  end

  it "creates provided supervisor administrator and grand employer administrator" do
    administrator = build(:administrator)
    employer1 = create(:employer)
    employer2 = create(:employer)

    attrs1 = {
      first_name: "Supervisor",
      last_name: "Supervisor",
      email: "supervisor@gmail.com",
      roles: [:employer_recruiter],
      ensure_employer_is_set: true,
      employer_id: employer1.id
    }

    attrs2 = {
      first_name: "Grand Employer",
      last_name: "Grand Employer",
      email: "grand.employer@gmail.com",
      roles: [:employer_recruiter],
      ensure_employer_is_set: true,
      employer_id: employer2.id
    }

    expect {
      administrator.supervisor_administrator_attributes = attrs1
      administrator.grand_employer_administrator_attributes = attrs2
      administrator.save!
    }.to change(described_class, :count).by(3)
  end

  describe "administrator_email_suffix" do
    let(:organization) { Organization.first }

    before do
      organization.update(administrator_email_suffix: "@gmail.com")
    end

    it "is valid with valid attributes" do
      administrator_valid = create(:administrator, email: "admin@gmail.com")
      expect(administrator_valid).to be_valid

      organization.update(administrator_email_suffix: "@laposte.net")
      expect(administrator_valid.reload).not_to be_valid
    end

    it "is invalid with invalid attributes" do
      administrator_invalid = build(:administrator, email: "admin@laposte.net")
      expect(administrator_invalid).not_to be_valid

      organization.update(administrator_email_suffix: "@laposte.net")
      administrator_invalid = build(:administrator, email: "admin@laposte.net")
      expect(administrator_invalid).to be_valid
    end
  end

  describe "automatic deactivation" do
    before do
      ENV["DAYS_INACTIVITY_PERIOD_BEFORE_DEACTIVATION"] = "100"
      ENV["DAYS_NOTICE_PERIOD_BEFORE_DEACTIVATION"] = "20"
      administrator.reload
      described_class.deactivate_when_too_old!
      administrator.reload
    end

    context "when connected long time ago" do
      let!(:administrator) { create(:administrator, last_sign_in_at: 81.days.ago) }

      it "marked" do
        expect(administrator.marked_for_deactivation_on).to eq(Time.zone.now.to_date)
      end
    end

    context "when marked yesterday and has not connected since" do
      let!(:administrator) { create(:administrator, marked_for_deactivation_on: 1.day.ago, last_sign_in_at: 101.days.ago) }

      it "dont delete" do
        expect(administrator.deleted_at.blank?).to be(true)
      end
    end

    context "when marked more than 20 days ago and has not connected since" do
      let!(:administrator) do
        administrator = create(:administrator, last_sign_in_at: 101.days.ago)
        administrator.update_column(:marked_for_deactivation_on, 21.days.ago) # rubocop:disable Rails/SkipsModelValidations
        administrator
      end

      it "delete" do
        expect(administrator.deleted_at&.to_date).to eq(Time.zone.now.to_date)
      end
    end

    context "when not marked and has not connected since" do
      let!(:administrator) { create(:administrator, last_sign_in_at: 101.days.ago) }

      it "marked & dont delete" do
        expect(administrator.marked_for_deactivation_on).to eq(Time.zone.now.to_date)
        expect(administrator.deleted_at.blank?).to be(true)
      end
    end

    context "when marked and has connected since" do
      let!(:administrator) { create(:administrator, marked_for_deactivation_on: 21.days.ago, last_sign_in_at: Time.zone.now) }

      it "doesn't delete" do
        expect(administrator.deleted_at).to be_nil
      end
    end
  end

  describe "#transfer" do
    let(:email) { "any@email.org" }
    let!(:job_offer) { create(:job_offer, owner: administrator) }

    context "when the new administrator exists" do
      let!(:new_administrator) { create(:administrator, email: email) }

      it "returns a persisted administrator" do
        expect(administrator.transfer(email).persisted?).to be(true)
      end

      it "doesn't create an administrator" do
        expect { administrator.transfer(email) }.not_to change(described_class, :count)
      end

      it "transfers the job offers to the new administrator" do
        expect { administrator.transfer(email) }.to change { job_offer.reload.owner }.to(new_administrator)
      end
    end

    context "when the new administrator does not exist" do
      it "returns a persisted administrator" do
        expect(administrator.transfer(email).persisted?).to be(true)
      end

      it "creates a new administrator" do
        expect { administrator.transfer(email) }.to change(described_class, :count).by(1)
      end

      it "transfers the job offers to the new administrator" do
        expect { administrator.transfer(email) }.to change { job_offer.reload.owner }
      end
    end

    context "when the organization has an administrator email suffix which isn't used by the new administrator" do
      before { administrator.organization.update!(administrator_email_suffix: "example.com") }

      it "returns a unpersisted administrator with errors" do
        expect(administrator.transfer(email).persisted?).to be(false)
        expect(administrator.transfer(email).errors).to be_present
      end

      it "doesn't transfer the job offers" do
        expect { administrator.transfer(email) }.not_to change { job_offer.reload.owner }
      end
    end
  end
end

# == Schema Information
#
# Table name: administrators
#
#  id                              :uuid             not null, primary key
#  ace                             :boolean          default(FALSE)
#  ate                             :boolean          default(FALSE)
#  confirmation_sent_at            :datetime
#  confirmation_token              :string
#  confirmed_at                    :datetime
#  current_sign_in_at              :datetime
#  current_sign_in_ip              :inet
#  deleted_at                      :datetime
#  email                           :string           default(""), not null
#  encrypted_password              :string           default(""), not null
#  failed_attempts                 :integer          default(0), not null
#  first_name                      :string
#  last_name                       :string
#  last_sign_in_at                 :datetime
#  last_sign_in_ip                 :inet
#  locked_at                       :datetime
#  marked_for_deactivation_on      :date
#  photo_content_type              :string
#  photo_file_name                 :string
#  photo_file_size                 :bigint
#  photo_updated_at                :datetime
#  reset_password_sent_at          :datetime
#  reset_password_token            :string
#  role                            :integer
#  roles                           :integer          default([]), not null
#  sign_in_count                   :integer          default(0), not null
#  title                           :string
#  unconfirmed_email               :string
#  unlock_token                    :string
#  very_first_account              :boolean          default(FALSE)
#  created_at                      :datetime         not null
#  updated_at                      :datetime         not null
#  employer_id                     :uuid
#  grand_employer_administrator_id :uuid
#  inviter_id                      :uuid
#  organization_id                 :uuid
#  supervisor_administrator_id     :uuid
#
# Indexes
#
#  index_administrators_on_confirmation_token               (confirmation_token) UNIQUE
#  index_administrators_on_email                            (email) UNIQUE
#  index_administrators_on_employer_id                      (employer_id)
#  index_administrators_on_grand_employer_administrator_id  (grand_employer_administrator_id)
#  index_administrators_on_inviter_id                       (inviter_id)
#  index_administrators_on_organization_id                  (organization_id)
#  index_administrators_on_reset_password_token             (reset_password_token) UNIQUE
#  index_administrators_on_supervisor_administrator_id      (supervisor_administrator_id)
#  index_administrators_on_unlock_token                     (unlock_token) UNIQUE
#
# Foreign Keys
#
#  fk_rails_6ebddde259  (grand_employer_administrator_id => administrators.id)
#  fk_rails_92b1b055db  (supervisor_administrator_id => administrators.id)
#  fk_rails_cc9399b781  (employer_id => employers.id)
#  fk_rails_d10e15274b  (inviter_id => administrators.id)
#
