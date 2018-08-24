require 'rails_helper'

RSpec.describe "admin/job_applications/show", type: :view do
  before(:each) do
    @job_application = assign(:job_application, create(:job_application))
    @message = assign(:message, build(:message, job_application: @job_application))
    @email = assign(:email, build(:email, job_application: @job_application))
  end

  it "renders attributes in <p>" do
    render
    # expect(rendered).to match(//)
    # expect(rendered).to match(//)
    # expect(rendered).to match(/First Name/)
    # expect(rendered).to match(/Last Name/)
    # expect(rendered).to match(/Current Position/)
    # expect(rendered).to match(/Phone/)
    # expect(rendered).to match(/Address 1/)
    # expect(rendered).to match(/Address 2/)
    # expect(rendered).to match(/Postal Code/)
    # expect(rendered).to match(/City/)
    # expect(rendered).to match(/Country/)
    # expect(rendered).to match(/Portfolio Url/)
    # expect(rendered).to match(/Website Url/)
    # expect(rendered).to match(/Linkedin Url/)
  end
end
