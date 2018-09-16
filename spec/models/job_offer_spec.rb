require 'rails_helper'

RSpec.describe JobOffer, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

RSpec.describe JobOffer do
	it 'should be invalid if duration <> nil when type = CDI' do
		leType = build(:contract_type, name: 'CDI')
		jb = build(:job_offer, contract_type: leType, duration_contract: "2 mois")
		jb.valid?
		expect(jb.valid?).to be_falsey
	end

	it 'should be invalid if duration <> nil when type = Interim' do
		leType = build(:contract_type, name: 'Interim')
		jb = build(:job_offer, contract_type: leType, duration_contract: "2 mois")
		
		expect(jb.valid?).to be_falsey
	end

	it 'should be valid if duration = nil when type = Interim' do
		leType = build(:contract_type, name: 'Interim')
		jb = build(:job_offer, contract_type: leType, duration_contract: nil)
		
		expect(jb.valid?).to be_truthy
	end

	it 'should be invalid if duration = nil when type = CDD' do
		leType = build(:contract_type, name: 'CDD')
		jb = build(:job_offer, contract_type: leType, duration_contract: nil)
		
		expect(jb.valid?).to be_falsey
	end

	it 'should be valid cdd if duration is edit when type = CDD' do
		leType = build(:contract_type, name: 'CDD')
		jb = build(:job_offer, contract_type: leType, duration_contract: "2 mois")
		
		expect(jb.valid?).to be_truthy
	end
end
