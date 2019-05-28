# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  before(:all) do
    @user = create(:user)
  end

  it 'is valid with valid attributes' do
    expect(@user).to be_valid
  end

  it 'should correctly answer if already applied or not' do
    user = create(:user)

    job_application_file_type = create(:job_application_file_type)
    file = fixture_file_upload('files/document.pdf', 'application/pdf')
    jaf_attrs = [
      {
        content: file,
        job_application_file_type_id: job_application_file_type.id
      }
    ]
    job_application = create(:job_application,
                             user: user,
                             job_application_files_attributes: jaf_attrs)

    expect(job_application).to be_valid

    already_applied = user.already_applied?(job_application.job_offer)

    expect(already_applied).to be_truthy

    another_job_offer = create(:job_offer)

    another_already_applied = user.already_applied?(another_job_offer)

    expect(another_already_applied).to be_falsey
  end
end
