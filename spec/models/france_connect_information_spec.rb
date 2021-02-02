# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FranceConnectInformation, type: :model do
  describe 'unique sub' do
    context 'with twice the same sub' do
      let(:fci) { FactoryBot.create(:france_connect_information) }
      let(:fci_second) { FactoryBot.build(:france_connect_information, sub: fci.sub) }

      it 'is unvalid' do
        expect(fci_second).to be_invalid
      end
    end
  end
end
