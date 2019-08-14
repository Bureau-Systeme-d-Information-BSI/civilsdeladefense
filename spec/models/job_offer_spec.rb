# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JobOffer, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

RSpec.describe JobOffer do
  it 'should be invalid if duration <> nil when type = CDI' do
    le_type = contract_types(:cdi)
    job_offer = build(:job_offer, contract_type: le_type, duration_contract: '2 mois')

    expect(job_offer.valid?).to be_falsey
  end

  it 'should be invalid if duration <> nil when type = Interim' do
    le_type = contract_types(:interim)
    job_offer = build(:job_offer, contract_type: le_type, duration_contract: '2 mois')

    expect(job_offer.valid?).to be_falsey
  end

  it 'should be valid if duration = nil when type = Interim' do
    le_type = contract_types(:interim)
    job_offer = build(:job_offer, contract_type: le_type, duration_contract: nil)

    expect(job_offer.valid?).to be_truthy
  end

  it 'should be invalid if duration = nil when type = CDD' do
    le_type = contract_types(:cdd)
    job_offer = build(:job_offer, contract_type: le_type, duration_contract: nil)

    expect(job_offer.valid?).to be_falsey
  end

  it 'should be valid cdd if duration is edit when type = CDD' do
    le_type = contract_types(:cdd)
    job_offer = build(:job_offer, contract_type: le_type, duration_contract: '2 mois')

    expect(job_offer.valid?).to be_truthy
  end

  it 'should set published_at date when state is published' do
    job_offer = create(:job_offer)
    expect(job_offer.state).to eq('draft')
    expect(job_offer.published_at).to be_nil
    job_offer.publish!
    expect(job_offer.state).to eq('published')
    expect(job_offer.published_at).not_to be_nil
  end
  it 'should set archived_at date when state is archived' do
    job_offer = create(:job_offer)
    expect(job_offer.state).to eq('draft')
    expect(job_offer.archived_at).to be_nil
    job_offer.publish!
    job_offer.archive!
    expect(job_offer.state).to eq('archived')
    expect(job_offer.archived_at).not_to be_nil
  end

  it 'should set suspended_at date when state is suspended' do
    job_offer = create(:job_offer)
    expect(job_offer.state).to eq('draft')
    expect(job_offer.suspended_at).to be_nil
    job_offer.publish!
    job_offer.suspend!
    expect(job_offer.state).to eq('suspended')
    expect(job_offer.suspended_at).not_to be_nil
  end

  it 'should correctly rebuild timestamp from audit log' do
    job_offer = create(:job_offer)
    job_offer.publish!
    published_at = job_offer.published_at
    expect(published_at).not_to be_nil
    job_offer.archive!
    archived_at = job_offer.archived_at
    expect(archived_at).not_to be_nil

    job_offer.update_columns({archived_at: nil, published_at: nil})
    expect(job_offer.published_at).to be_nil
    expect(job_offer.archived_at).to be_nil

    job_offer.rebuild_published_timestamp!
    job_offer.reload
    expect(job_offer.published_at).not_to be_nil
    time_diff = (published_at - job_offer.published_at).abs
    expect(time_diff).to be_within(1.0).of(1.0)

    job_offer.rebuild_archived_timestamp!
    job_offer.reload
    expect(job_offer.archived_at).not_to be_nil
    time_diff = (published_at - job_offer.published_at).abs
    expect(time_diff).to be_within(1.0).of(1.0)
  end

  it 'should correctly find current most advanced job application state' do
    job_offer = create(:job_offer)
    job_applications = create_list(:job_application, 10, job_offer: job_offer)
    expect(job_offer.current_most_advanced_job_applications_state).to eq(0)
    last_state_name, last_state_enum = JobApplication.states.to_a.last
    job_applications.last.send("#{last_state_name}!")
    expect(job_offer.current_most_advanced_job_applications_state).to eq(last_state_enum)
  end

  it 'should be visible by owner' do
    employer = create(:employer)
    owner = create(:administrator, role: 'employer', employer: employer)
    job_offer = create(:job_offer, owner: owner)
    ability = Ability.new(owner)
    expect(ability.can?(:manage, job_offer)).to be true
  end

  it 'should be visible by actors' do
    employer = create(:employer)
    brh = create(:administrator, role: nil, employer: employer)
    other_admin = create(:administrator, role: nil, employer: employer)

    job_offer = create(:job_offer) do |obj|
      actor_attrs = attributes_for(:job_offer_actor, role: 'brh', administrator: brh)
      obj.job_offer_actors.create(actor_attrs)
    end

    ability = Ability.new(brh)
    expect(ability.can?(:read, job_offer)).to be true

    ability = Ability.new(other_admin)
    expect(ability.can?(:manage, job_offer)).to be false
    expect(ability.can?(:read, job_offer)).to be false
  end
end
