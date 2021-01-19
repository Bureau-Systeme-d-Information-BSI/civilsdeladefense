# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JobOfferActor, type: :model do
  let(:job_offer_actor) { create(:job_offer_actor) }
  let(:job_offer) { job_offer_actor.job_offer }

  describe 'administrator_attributes=' do
    let(:administrator) { create(:administrator) }

    before do
      job_offer_actor.administrator_attributes = attributes
    end

    context 'with _destroy' do
      let(:attributes) { { '_destroy' => true } }

      it 'marked job_offer_actor for destroy' do
        expect(job_offer_actor.marked_for_destruction?).to eq(true)
      end
    end

    context 'without _destroy' do
      let(:attributes) { {} }

      it 'doesnt marked job_offer_actor for destroy' do
        expect(job_offer_actor.marked_for_destruction?).to eq(false)
      end
    end

    context 'with administrator id' do
      let(:administrator) { create(:administrator) }
      let(:attributes) { { id: administrator.id } }

      it 'set administrator' do
        expect(job_offer_actor.administrator).to eq(administrator)
      end
    end

    context 'with administrator email' do
      let(:email) { Faker::Internet.safe_email }
      let(:attributes) { { email: email } }

      it 'build an administrator' do
        expect(job_offer_actor.administrator.email).to eq(email)
      end

      it 'set inviter to job_offer owner' do
        expect(job_offer_actor.administrator.inviter).to eq(job_offer.owner)
      end
    end
  end
end
