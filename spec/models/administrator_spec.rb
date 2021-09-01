# frozen_string_literal: true

require "rails_helper"

RSpec.describe Administrator, type: :model do
  let(:administrator) { create(:administrator) }

  it "is valid with valid attributes" do
    expect(administrator).to be_valid
  end

  it "has a unique email" do
    administrator2 = build(:administrator, email: administrator.email)
    expect(administrator2).to_not be_valid
  end

  it "lock the administrator after 10 wrong authentication attempts" do
    1.upto(9) do |i|
      administrator.valid_for_authentication? { false }
      expect(administrator.failed_attempts).to eq(i)
      expect(administrator.locked_at).to be_nil
    end

    administrator.valid_for_authentication? { false }
    expect(administrator.failed_attempts).to eq(10)
    expect(administrator.locked_at).to_not be_nil
  end

  it "check correctly the confirmation token validity duration" do
    expect(administrator.confirmation_token_still_valid?).to be_truthy

    administrator2 = build(:administrator, confirmed_at: nil, confirmation_sent_at: 4.days.ago)
    expect(administrator2.confirmation_token_still_valid?).to be_falsy
  end

  it "creates provided supervisor administrator when non-preexisting" do
    administrator = build(:administrator)
    employer = create(:employer)

    attrs = {
      email: "supervisor@gmail.com",
      ensure_employer_is_set: true,
      employer_id: employer.id
    }

    expect {
      administrator.supervisor_administrator_attributes = attrs
      administrator.save
    }.to change(Administrator, :count).by(2)

    expect(administrator.supervisor_administrator.email).to eq("supervisor@gmail.com")
  end

  it "creates provided supervisor administrator when preexisting" do
    employer = create(:employer)
    supervisor_administrator = create(:administrator, employer: employer)
    administrator = build(:administrator)

    attrs = {
      email: supervisor_administrator.email,
      ensure_employer_is_set: true,
      employer_id: employer.id
    }

    expect {
      administrator.supervisor_administrator_attributes = attrs
      administrator.save
    }.to change(Administrator, :count).by(1)

    expect(administrator.supervisor_administrator.email).to eq(supervisor_administrator.email)
  end

  it "creates provided grand employer administrator when non-preexisting" do
    administrator = build(:administrator)
    employer = create(:employer)

    attrs = {
      email: "grand.employer@gmail.com",
      ensure_employer_is_set: true,
      employer_id: employer.id
    }

    expect {
      administrator.grand_employer_administrator_attributes = attrs
      administrator.save
    }.to change(Administrator, :count).by(2)

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
    }.to change(Administrator, :count).by(1)

    expect(administrator.grand_employer_administrator.email).to eq(email)
  end

  it "creates provided supervisor administrator and grand employer administrator" do
    administrator = build(:administrator)
    employer1 = create(:employer)
    employer2 = create(:employer)

    attrs1 = {
      email: "supervisor@gmail.com",
      ensure_employer_is_set: true,
      employer_id: employer1.id
    }

    attrs2 = {
      email: "grand.employer@gmail.com",
      ensure_employer_is_set: true,
      employer_id: employer2.id
    }

    expect {
      administrator.supervisor_administrator_attributes = attrs1
      administrator.grand_employer_administrator_attributes = attrs2
      administrator.save
    }.to change(Administrator, :count).by(3)
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
      expect(administrator_valid.reload).to be_invalid
    end

    it "is invalid with invalid attributes" do
      administrator_invalid = build(:administrator, email: "admin@laposte.net")
      expect(administrator_invalid).to be_invalid

      organization.update(administrator_email_suffix: "@laposte.net")
      administrator_invalid = build(:administrator, email: "admin@laposte.net")
      expect(administrator_invalid).to be_valid
    end
  end

  it "should compute notice period difference in days" do
    ENV["DAYS_INACTIVITY_PERIOD_BEFORE_DEACTIVATION"] = "100"
    ENV["DAYS_NOTICE_PERIOD_BEFORE_DEACTIVATION"] = "20"
    expect(Administrator.notice_period_target_date.to_date).to eq(80.days.ago.to_date)
  end

  describe "automatic deactivation" do
    before do
      ENV["DAYS_INACTIVITY_PERIOD_BEFORE_DEACTIVATION"] = "100"
      ENV["DAYS_NOTICE_PERIOD_BEFORE_DEACTIVATION"] = "20"
      administrator.reload
      Administrator.deactivate_when_too_old
      administrator.reload
    end

    context "connected long time ago" do
      let!(:administrator) { create(:administrator, last_sign_in_at: 81.days.ago) }

      it "marked" do
        expect(administrator.marked_for_deactivation_on).to eq(Time.zone.now.to_date)
      end
    end

    context "marked yesterday and has not connected since" do
      let!(:administrator) { create(:administrator, marked_for_deactivation_on: 1.day.ago, last_sign_in_at: 101.days.ago) }

      it "dont delete" do
        expect(administrator.deleted_at.blank?).to eq(true)
      end
    end

    context "marked more than 20 days ago and has not connected since" do
      let!(:administrator) do
        administrator = create(:administrator, last_sign_in_at: 101.days.ago)
        administrator.update_column(:marked_for_deactivation_on, 21.days.ago)
        administrator
      end

      it "delete" do
        expect(administrator.deleted_at&.to_date).to eq(Time.zone.now.to_date)
      end
    end

    context "not marked and has not connected since" do
      let!(:administrator) { create(:administrator, last_sign_in_at: 101.days.ago) }

      it "marked & dont delete" do
        expect(administrator.marked_for_deactivation_on).to eq(Time.zone.now.to_date)
        expect(administrator.deleted_at.blank?).to eq(true)
      end
    end

    context "marked and has connected since" do
      let!(:administrator) { create(:administrator, marked_for_deactivation_on: 21.days.ago, last_sign_in_at: Time.zone.now) }

      it "doesn't delete" do
        expect(administrator.deleted_at).to eq(nil)
      end
    end
  end
end

# == Schema Information
#
# Table name: administrators
#
#  id                              :uuid             not null, primary key
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
