# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserProfile, type: :model do
  before(:all) do
    @user = create(:user)
    @user_profile = @user.user_profile
  end

  it 'is valid with valid attributes' do
    expect(@user_profile).to be_valid
  end

  it 'has correct gender' do
    @user_profile.gender = 2
    expect(@user_profile.gender).to eq('male')
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

    @user_profile.update gender: 'female'
    @user_profile.datalake_to_job_application_profiles!

    expect(@user_profile.gender).to eq('female')
    job_application.user_profile.reload
    expect(job_application.user_profile.gender).to eq('female')
    job_application2.user_profile.reload
    expect(job_application2.user_profile.gender).to eq('female')

    @user_profile.update gender: 'male'
    @user_profile.datalake_to_job_application_profiles!

    expect(@user_profile.gender).to eq('male')
    job_application.user_profile.reload
    expect(job_application.user_profile.gender).to eq('male')
    job_application2.user_profile.reload
    expect(job_application2.user_profile.gender).to eq('male')

    job_offer2.archive!

    @user_profile.update gender: 'female'
    @user_profile.datalake_to_job_application_profiles!

    expect(@user_profile.gender).to eq('female')
    job_application.user_profile.reload
    expect(job_application.user_profile.gender).to eq('female')
    job_application2.user_profile.reload
    expect(job_application2.user_profile.gender).to eq('male')
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

    @user_profile.update gender: 'female'
    @user_profile.datalake_to_job_application_profiles!

    expect(@user_profile.gender).to eq('female')
    job_application.user_profile.reload
    expect(job_application.user_profile.gender).to eq('female')
    job_application2.user_profile.reload
    expect(job_application2.user_profile.gender).to eq('female')

    @user_profile.update gender: 'male'
    @user_profile.datalake_to_job_application_profiles!(except: job_application2.id)

    expect(@user_profile.gender).to eq('male')
    job_application.user_profile.reload
    expect(job_application.user_profile.gender).to eq('male')
    job_application2.user_profile.reload
    expect(job_application2.user_profile.gender).to eq('female')
  end
end
