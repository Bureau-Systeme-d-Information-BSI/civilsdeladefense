# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicantNotificationsMailer, type: :mailer do
  describe 'new_email from organization without inbound email configured' do
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

  describe 'new_new_email from organization with inbound email configured with catch_all' do
    let(:mail) do
      @job_offer = create(:job_offer)
      organization = @job_offer.organization
      organization.inbound_email_config = :catch_all
      organization.save
      @job_application = create(:job_application, job_offer: @job_offer)
      email = create(:email, job_application: @job_application)
      ApplicantNotificationsMailer.new_email(email.id)
    end

    it 'renders the headers' do
      expect(mail.subject).to eq('New email')
      expect(mail.to).to eq([@job_application.user.email])
      expect(mail.from).to eq(['hello@localhost'])
      expect(mail.reply_to.first).to match(/\+/)
      expect(mail.header['Message-ID']).to be_nil
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match(/Vous recevez ce message parce que vous avez candidat/)
      expect(mail.body.encoded).to match(/vous pouvez répondre à cet email directement/)
    end
  end

  describe 'new_new_email from organization with inbound email configured with hidden_headers' do
    let(:mail) do
      @job_offer = create(:job_offer)
      organization = @job_offer.organization
      organization.inbound_email_config = :hidden_headers
      organization.save
      @job_application = create(:job_application, job_offer: @job_offer)
      @email = create(:email, job_application: @job_application)
      ApplicantNotificationsMailer.new_email(@email.id)
    end

    it 'renders the headers' do
      expect(mail.subject).to eq('New email')
      expect(mail.to).to eq([@job_application.user.email])
      expect(mail.from).to eq(['hello@localhost'])
      expect(mail.reply_to.first).not_to match(/\+/)
      expect(mail.header['Message-ID'].value).to eq("<#{@email.id}@localhost>")
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match(/Vous recevez ce message parce que vous avez candidat/)
      expect(mail.body.encoded).to match(/vous pouvez répondre à cet email directement/)
    end
  end
end
