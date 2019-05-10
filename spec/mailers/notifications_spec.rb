# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NotificationsMailer, type: :mailer do
  describe 'daily_summary' do
    let(:administrator) do
      create(:administrator, email: 'to@example.org')
    end
    let(:mail) do
      data = [
        {
          title: 'TEST OFFRE',
          link: 'https://google.com',
          kind: 'NewJobOffer'
        }
      ]
      NotificationsMailer.daily_summary(administrator, data)
    end

    it 'renders the headers' do
      expect(mail.subject).to match('Rapport')
      expect(mail.to).to eq(['to@example.org'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match('TEST OFFRE')
    end
  end
end
