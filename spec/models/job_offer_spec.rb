# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JobOffer, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

RSpec.describe JobOffer do
  it 'should be invalid if duration <> nil when type = CDI' do
    le_type = build(:contract_type, name: 'CDI')
    jb = build(:job_offer, contract_type: le_type, duration_contract: '2 mois')

    expect(jb.valid?).to be_falsey
  end

  it 'should be invalid if duration <> nil when type = Interim' do
    le_type = build(:contract_type, name: 'Interim')
    jb = build(:job_offer, contract_type: le_type, duration_contract: '2 mois')

    expect(jb.valid?).to be_falsey
  end

  it 'should be valid if duration = nil when type = Interim' do
    le_type = build(:contract_type, name: 'Interim')
    jb = build(:job_offer, contract_type: le_type, duration_contract: nil)

    expect(jb.valid?).to be_truthy
  end

  it 'should be invalid if duration = nil when type = CDD' do
    le_type = build(:contract_type, name: 'CDD')
    jb = build(:job_offer, contract_type: le_type, duration_contract: nil)

    expect(jb.valid?).to be_falsey
  end

  it 'should be valid cdd if duration is edit when type = CDD' do
    le_type = build(:contract_type, name: 'CDD')
    jb = build(:job_offer, contract_type: le_type, duration_contract: '2 mois')

    expect(jb.valid?).to be_truthy
  end

  it 'should set published_at date when state is published' do
    jb = create(:job_offer)
    expect(jb.state).to eq('draft')
    expect(jb.published_at).to be_nil
    jb.publish!
    expect(jb.state).to eq('published')
    expect(jb.published_at).not_to be_nil
  end
end
