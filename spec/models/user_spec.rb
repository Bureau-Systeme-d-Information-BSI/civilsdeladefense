# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  before(:all) do
    @user = create(:confirmed_user)
  end

  it 'is valid with valid attributes' do
    expect(@user).to be_valid
  end

  it 'can be suspended' do
    text = 'Bad guy'
    expect(@user.suspended_at).to be_nil
    expect(@user.active_for_authentication?).to be_truthy
    @user.suspend!(text)
    expect(@user.suspended?).to be_truthy
    expect(@user.suspended_at).to_not be_nil
    expect(@user.suspension_reason).to eq(text)
    expect(@user.active_for_authentication?).to be_falsey
  end

  it 'cannot be destroyed when suspended' do
    @user.unsuspend!
    expect { @user.destroy }.to change(User, :count).by(-1)

    @another_user = create(:confirmed_user)
    @another_user.unsuspend!
    @another_user.suspend!('Bad guy')
    expect(@another_user.suspended?).to be_truthy
    expect { @another_user.destroy }.to change(User, :count).by(0)
  end

  it 'should purge associated objects when destroyed' do
    job_application_file_type = create(:job_application_file_type)

    job_application = create(:job_application, user: @user)
    job_application_file = build(:job_application_file,
                                 job_application_file_type: job_application_file_type)
    job_application.job_application_files << job_application_file

    count = job_application.job_application_files.count
    expect(count).to eq(1)

    @user.unsuspend!
    count_before = JobApplicationFile.count
    expect(count_before).to eq(1)

    @user.destroy
    count_after = JobApplicationFile.count
    expect(count_after).to eq(count_before - 1)
  end

  it 'should compute notice period difference in days' do
    ENV['NBR_DAYS_INACTIVITY_PERIOD_BEFORE_DELETION'] = '100'
    ENV['NBR_DAYS_NOTICE_PERIOD_BEFORE_DELETION'] = '20'
    expect(User.notice_period_target_date.to_date).to eq(80.days.ago.to_date)
  end

  it 'should correctly answer if already applied or not' do
    job_application_file_type = create(:job_application_file_type)
    job_application = create(:job_application, user: @user)
    expect(job_application).to be_valid

    create(:job_application_file,
           job_application: job_application,
           job_application_file_type: job_application_file_type)

    already_applied = @user.already_applied?(job_application.job_offer)

    expect(already_applied).to be_truthy

    another_job_offer = create(:job_offer)

    another_already_applied = @user.already_applied?(another_job_offer)

    expect(another_already_applied).to be_falsey
  end

  it 'should correctly count active job applications' do
    job_application_file_type = create(:job_application_file_type)
    file = fixture_file_upload('document.pdf', 'application/pdf')
    jaf_attrs = [
      {
        content: file,
        job_application_file_type_id: job_application_file_type.id
      }
    ]
    job_application = create(:job_application,
                             user: @user,
                             job_application_files_attributes: jaf_attrs)

    expect(job_application).to be_valid

    job_application_file_type = create(:job_application_file_type)
    file = fixture_file_upload('document.pdf', 'application/pdf')
    jaf_attrs = [
      {
        content: file,
        job_application_file_type_id: job_application_file_type.id
      }
    ]
    job_application2 = create(:job_application,
                              user: @user,
                              job_application_files_attributes: jaf_attrs)

    expect(job_application2).to be_valid

    expect(@user.job_applications_active.count).to eq(2)

    job_offer = job_application2.job_offer
    job_offer.publish!
    job_offer.archive!

    expect(@user.job_applications_active.count).to eq(1)
  end

  describe 'required password' do
    let(:user) { FactoryBot.build(:user) }

    context 'with omniauth_informations' do
      before do
        FactoryBot.create_list(:omniauth_information, 10, user: user)
        user.password = ''
      end

      it 'is not required' do
        expect(user).to be_valid
      end
    end

    context 'without omniauth_informations' do
      before do
        user.password = ''
      end

      it 'is required' do
        expect(user).to be_invalid
      end
    end
  end
end
