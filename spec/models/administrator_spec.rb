# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Administrator, type: :model do
  before(:all) do
    @administrator = create(:administrator)
  end

  it 'is valid with valid attributes' do
    expect(@administrator).to be_valid
  end

  it 'has a unique email' do
    administrator2 = build(:administrator, email: @administrator.email)
    expect(administrator2).to_not be_valid
  end

  it 'lock the administrator after 10 wrong authentication attempts' do
    1.upto(9) do |i|
      @administrator.valid_for_authentication? { false }
      expect(@administrator.failed_attempts).to eq(i)
      expect(@administrator.locked_at).to be_nil
    end

    @administrator.valid_for_authentication? { false }
    expect(@administrator.failed_attempts).to eq(10)
    expect(@administrator.locked_at).to_not be_nil
  end

  it 'creates provided supervisor administrator' do
    administrator = build(:administrator)
    employer = create(:employer)

    attrs = {
      email: 'supervisor@gmail.com',
      ensure_employer_is_set: true,
      employer_id: employer.id
    }

    expect do
      administrator.supervisor_administrator_attributes = attrs
      administrator.save
    end.to change(Administrator, :count).by(2)
  end

  it 'creates provided grand employer administrator' do
    administrator = build(:administrator)
    employer = create(:employer)

    attrs = {
      email: 'grand.employer@gmail.com',
      ensure_employer_is_set: true,
      employer_id: employer.id
    }

    expect do
      administrator.grand_employer_administrator_attributes = attrs
      administrator.save
    end.to change(Administrator, :count).by(2)
  end

  it 'creates provided supervisor administrator and grand employer administrator' do
    administrator = build(:administrator)
    employer1 = create(:employer)
    employer2 = create(:employer)

    attrs1 = {
      email: 'supervisor@gmail.com',
      ensure_employer_is_set: true,
      employer_id: employer1.id
    }

    attrs2 = {
      email: 'grand.employer@gmail.com',
      ensure_employer_is_set: true,
      employer_id: employer2.id
    }

    expect do
      administrator.supervisor_administrator_attributes = attrs1
      administrator.grand_employer_administrator_attributes = attrs2
      administrator.save
    end.to change(Administrator, :count).by(3)
  end

  describe 'with ADMINISTRATOR_EMAIL_SUFFIX env variable defined' do
    before(:all) do
      ENV['ADMINISTRATOR_EMAIL_SUFFIX'] = '@gmail.com'
    end

    after(:all) do
      ENV['ADMINISTRATOR_EMAIL_SUFFIX'] = nil
    end

    it 'is valid with valid attributes' do
      administrator_valid = create(:administrator, email: 'admin@gmail.com')
      expect(administrator_valid).to be_valid
    end

    it 'is invalid with invalid attributes' do
      administrator_invalid = build(:administrator, email: 'admin@laposte.net')
      expect(administrator_invalid).to be_invalid
    end

    it 'is valid with valid attributes and org takes precedence' do
      administrator_valid = create(:administrator, email: 'admin@gmail.com')
      expect(administrator_valid).to be_valid

      org = administrator_valid.organization
      org.update_attribute(:administrator_email_suffix, '@laposte.net')
      expect(administrator_valid).to be_invalid
    end

    it 'is invalid with invalid attributes and org takes precedence' do
      administrator_invalid = build(:administrator, email: 'admin@laposte.net')
      expect(administrator_invalid).to be_invalid

      org = administrator_invalid.organization
      org.update_attribute(:administrator_email_suffix, '@laposte.net')
      expect(administrator_invalid).to be_valid
    end
  end
end
