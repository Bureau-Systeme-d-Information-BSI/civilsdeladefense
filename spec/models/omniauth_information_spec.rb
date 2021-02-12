# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OmniauthInformation, type: :model do
  describe 'unique uid' do
    context 'with twice the same uid/provider' do
      let(:fci) { FactoryBot.create(:omniauth_information) }
      let(:fci_second) do
        FactoryBot.build(:omniauth_information, uid: fci.uid, provider: fci.provider)
      end

      it 'is unvalid' do
        expect(fci_second).to be_invalid
      end
    end
  end
end
