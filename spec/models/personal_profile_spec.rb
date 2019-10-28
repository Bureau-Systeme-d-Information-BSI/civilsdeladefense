# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PersonalProfile, type: :model do
  before(:all) do
    @user = create(:user)
    @personal_profile = @user.personal_profile
  end

  it 'is valid with valid attributes' do
    expect(@personal_profile).to be_valid
  end

  it 'has correct gender' do
    @personal_profile.gender = 2
    expect(@personal_profile.gender).to eq('male')
  end

  it 'correctly copies data to linked profiles' do
    job_offer = create(:job_offer)
    job_offer.publish!
    job_application = create(:job_application,
                             user: @user,
                             job_offer: job_offer)
    job_offer2 = create(:job_offer)
    job_offer2.publish!
    job_application2 = create(:job_application,
                              user: @user,
                              job_offer: job_offer2)

    expect(@user.job_applications.count).to eq(2)

    @personal_profile.update nationality: 'FR'
    @personal_profile.datalake_to_job_application_profiles!

    expect(@personal_profile.nationality).to eq('FR')
    job_application.personal_profile.reload
    expect(job_application.personal_profile.nationality).to eq('FR')
    job_application2.personal_profile.reload
    expect(job_application2.personal_profile.nationality).to eq('FR')

    @personal_profile.update nationality: 'DE'
    @personal_profile.datalake_to_job_application_profiles!

    expect(@personal_profile.nationality).to eq('DE')
    job_application.personal_profile.reload
    expect(job_application.personal_profile.nationality).to eq('DE')
    job_application2.personal_profile.reload
    expect(job_application2.personal_profile.nationality).to eq('DE')

    @personal_profile.update gender: 'female'
    @personal_profile.datalake_to_job_application_profiles!

    expect(@personal_profile.gender).to eq('female')
    job_application.personal_profile.reload
    expect(job_application.personal_profile.gender).to eq('female')
    job_application2.personal_profile.reload
    expect(job_application2.personal_profile.gender).to eq('female')

    @personal_profile.update gender: 'male'
    @personal_profile.datalake_to_job_application_profiles!

    expect(@personal_profile.gender).to eq('male')
    job_application.personal_profile.reload
    expect(job_application.personal_profile.gender).to eq('male')
    job_application2.personal_profile.reload
    expect(job_application2.personal_profile.gender).to eq('male')

    job_offer2.archive!

    @personal_profile.update nationality: 'FR'
    @personal_profile.datalake_to_job_application_profiles!

    expect(@personal_profile.nationality).to eq('FR')
    job_application.personal_profile.reload
    expect(job_application.personal_profile.nationality).to eq('FR')
    job_application2.personal_profile.reload
    expect(job_application2.personal_profile.nationality).to eq('DE')

    @personal_profile.update gender: 'female'
    @personal_profile.datalake_to_job_application_profiles!

    expect(@personal_profile.gender).to eq('female')
    job_application.personal_profile.reload
    expect(job_application.personal_profile.gender).to eq('female')
    job_application2.personal_profile.reload
    expect(job_application2.personal_profile.gender).to eq('male')
  end

  it 'correctly copies data to linked profiles and take care of except parameter' do
    job_offer = create(:job_offer)
    job_offer.publish!
    job_application = create(:job_application,
                             user: @user,
                             job_offer: job_offer)
    job_offer2 = create(:job_offer)
    job_offer2.publish!
    job_application2 = create(:job_application,
                              user: @user,
                              job_offer: job_offer2)

    @personal_profile.update nationality: 'FR'
    @personal_profile.datalake_to_job_application_profiles!

    expect(@personal_profile.nationality).to eq('FR')
    job_application.personal_profile.reload
    expect(job_application.personal_profile.nationality).to eq('FR')
    job_application2.personal_profile.reload
    expect(job_application2.personal_profile.nationality).to eq('FR')

    @personal_profile.update nationality: 'DE'
    @personal_profile.datalake_to_job_application_profiles!(except: job_application2.id)

    expect(@personal_profile.nationality).to eq('DE')
    job_application.personal_profile.reload
    expect(job_application.personal_profile.nationality).to eq('DE')
    job_application2.personal_profile.reload
    expect(job_application2.personal_profile.nationality).to eq('FR')
  end
end
