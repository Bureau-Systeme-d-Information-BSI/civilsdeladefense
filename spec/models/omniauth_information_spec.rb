# frozen_string_literal: true

require "rails_helper"

RSpec.describe OmniauthInformation do
  describe "unique uid" do
    context "with twice the same uid/provider" do
      let(:fci) { create(:omniauth_information) }
      let(:fci_second) do
        build(:omniauth_information, uid: fci.uid, provider: fci.provider)
      end

      it "is unvalid" do
        expect(fci_second).not_to be_valid
      end
    end
  end
end

# == Schema Information
#
# Table name: omniauth_informations
#
#  id         :uuid             not null, primary key
#  email      :string           not null
#  first_name :string
#  last_name  :string
#  provider   :string           not null
#  uid        :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :uuid
#
# Indexes
#
#  index_omniauth_informations_on_uid_and_provider  (uid,provider) UNIQUE
#  index_omniauth_informations_on_user_id           (user_id)
#
