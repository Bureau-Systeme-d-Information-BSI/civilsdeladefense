require 'rails_helper'

RSpec.describe JobOffer, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

RSpec.describe JobOffer do
	it 'should be invalid if duration <> nil when type = CDI' do
		leType = build(:contract_type, name: 'CDI')
		jb = build(:job_offer, contract_type: leType, duration_contract: "2 mois")
		jb.valid?
		expect(jb.duration_contract).to be_nil
	end

	it 'should be invalid if duration <> nil when type = Interim' do
		leType = build(:contract_type, name: 'Interim')
		jb = build(:job_offer, contract_type: leType, duration_contract: "2 mois")
		jb.valid?
		expect(jb.duration_contract).to be_nil
	end

	it 'should be invalid if duration is edit when type = CDD' do
		leType = build(:contract_type, name: 'CDD')
		duration = "2 mois"
		jb = build(:job_offer, contract_type: leType, duration_contract: duration)
		jb.valid?
		expect(jb.duration_contract).to match(duration)
	end

	
end
