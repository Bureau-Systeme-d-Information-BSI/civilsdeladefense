# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NotificationsMailer, type: :mailer do
  describe 'daily_summary' do
    let(:organization) do
      Organization.first
    end
    let(:administrator) do
      create(:administrator, email: 'to@example.org')
    end
    let(:mail) do
      data = [
        {
          title: 'Data Scientist',
          link: 'https://google.com',
          kind: 'NewJobOffer'
        },
        {
          title: 'Chef des Pompiers',
          link: 'https://google.com',
          kind: 'PublishedJobOffer'
        }
      ]
      site_name = organization.name
      NotificationsMailer.daily_summary(administrator, data, site_name)
    end

    it 'renders the headers' do
      expect(mail.subject).to match('Rapport')
      expect(mail.subject).to match(organization.name)
      expect(mail.to).to eq(['to@example.org'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match('Data Scientist')
      txt = I18n.t('notifications_mailer.daily_summary.new_job_offers.title')
      expect(mail.body.encoded).to match(txt)
      expect(mail.body.encoded).to match('Chef des Pompiers')
      txt = I18n.t('notifications_mailer.daily_summary.published_job_offers.title')
      expect(mail.body.encoded).to match(txt)
    end
  end
end
