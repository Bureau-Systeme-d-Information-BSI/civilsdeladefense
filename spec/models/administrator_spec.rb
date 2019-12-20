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

  it 'validates the password length' do
    administrator = build(:administrator)

    administrator.password = '*2E45678'
    expect(administrator).to be_invalid

    administrator.password = '*2E4567890'
    expect(administrator).to be_invalid

    administrator.password = '*2E45678901234'
    expect(administrator).to be_invalid

    administrator.password = '0' * 128 + '*' + 'A' + 'a'
    expect(administrator).to be_invalid

    administrator.password = '0' * 125 + '*' + 'A' + 'a'
    expect(administrator).to be_valid

    administrator.password = '*2E456789012e4'
    expect(administrator).to be_valid
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
  end
end
