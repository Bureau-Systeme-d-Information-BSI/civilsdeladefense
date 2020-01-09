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
