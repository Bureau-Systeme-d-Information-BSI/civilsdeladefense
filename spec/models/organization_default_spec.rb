# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OrganizationDefault, type: :model do
  it { should validate_presence_of(:kind) }
  it { should validate_presence_of(:value) }

  it 'sets the corresponding default value for a job offer' do
    administrator = create(:administrator)

    default = administrator.organization.organization_defaults.where(kind: 20).first
    expect(default.value).to eq('Yada Yada')

    job_offer_new = JobOffer.new_from_scratch(administrator)
    expect(job_offer_new.recruitment_process).to eq('Yada Yada')

    default.update_attribute :value, 'Yo'
    administrator.reload
    job_offer_new = JobOffer.new_from_scratch(administrator)
    expect(job_offer_new.recruitment_process).to eq('Yo')
  end
end
