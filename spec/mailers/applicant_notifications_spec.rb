# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicantNotificationsMailer, type: :mailer do
  describe 'new_email' do
    let(:mail) do
      @job_offer = create(:job_offer)
      @job_application = create(:job_application, job_offer: @job_offer)
      email = create(:email, job_application: @job_application)
      ApplicantNotificationsMailer.new_email(email.id)
    end

    it 'renders the headers' do
      expect(mail.subject).to eq('New email')
      expect(mail.to).to eq([@job_application.user.email])
      expect(mail.from).to eq(['hello@localhost'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match(/Vous recevez ce message parce que vous avez candidat/)
    end
  end
end
