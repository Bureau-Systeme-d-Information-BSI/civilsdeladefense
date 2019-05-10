# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'account/emails/index', type: :view do
  login_user

  before(:each) do
    job_application = create(:job_application, user: User.last)
    assign(:job_application, job_application)
    assign(:email, Email.new)
    ary = [
      Email.create!(
        subject: 'Subject',
        body: 'MyText',
        job_application: job_application,
        sender: User.last
      ),
      Email.create!(
        subject: 'Subject',
        body: 'MyText',
        job_application: job_application,
        sender: User.last
      )
    ]
    assign(:account_emails, ary)
  end

  it 'renders a list of account/emails' do
    render
    # assert_select "tr>td", text: "Subject".to_s, count: 2
    # assert_select "tr>td", text: "MyText".to_s, count: 2
  end
end
