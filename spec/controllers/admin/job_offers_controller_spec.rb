# frozen_string_literal: true

require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.
#
# Also compared to earlier versions of this generator, there are no longer any
# expectations of assigns and templates rendered. These features have been
# removed from Rails core in Rails 5, but can be added back in via the
# `rails-controller-testing` gem.

RSpec.describe Admin::JobOffersController, type: :controller do
  context 'when logged in as BANT administrator' do
    login_admin

    # This should return the minimal set of attributes required to create a valid
    # JobOffer. As you add validations to JobOffer, be sure to
    # adjust the attributes here as well.
    let(:valid_attributes) do
      hsh = build(:job_offer).attributes
      hsh[:employer_id] = create(:employer).id
      hsh[:category_id] = create(:category).id
      hsh
    end

    let(:invalid_attributes) do
      { title: '' }
    end

    describe 'GET #index' do
      it 'returns a success response' do
        create_list :job_offer, 5
        get :index, params: {}
        expect(response).to be_successful
        expect(assigns(:job_offers_active).size).to eq(5)
      end
    end

    describe 'GET #archived' do
      it 'returns a success response' do
        create_list :job_offer, 5
        create_list :job_offer, 3, state: :archived
        get :archived, params: {}
        expect(response).to be_successful
        expect(assigns(:job_offers_archived).size).to eq(3)
      end
    end

    describe 'GET #show' do
      it 'returns a success response' do
        job_offer = create :job_offer
        get :show, params: { id: job_offer.to_param }
        expect(response).to be_successful
      end
    end

    describe 'GET #board' do
      it 'returns a success response' do
        job_offer = create :job_offer
        get :board, params: { id: job_offer.to_param }
        expect(response).to be_successful
      end
    end

    describe 'GET #stats' do
      it 'returns a success response' do
        job_offer = create :job_offer
        get :stats, params: { id: job_offer.to_param }
        expect(response).to be_successful
      end
    end

    describe 'GET #new' do
      it 'returns a success response' do
        get :new, params: {}
        expect(response).to be_successful
      end
    end

    describe 'GET #edit' do
      it 'returns a success response' do
        job_offer = create :job_offer
        get :edit, params: { id: job_offer.to_param }
        expect(response).to be_successful
      end
    end

    describe 'POST #create' do
      context 'with valid params' do
        it 'creates a new JobOffer' do
          expect do
            post :create, params: { job_offer: valid_attributes }
          end.to change(JobOffer, :count).by(1)
        end

        it 'redirects to the created job_offer' do
          post :create, params: { job_offer: valid_attributes }
          expect(response).to redirect_to(%i[admin job_offers])
        end
      end

      context 'with invalid params' do
        it "returns a success response (i.e. to display the 'new' template)" do
          post :create, params: { job_offer: invalid_attributes }
          expect(response).to be_successful
        end
      end
    end

    describe 'POST #add_actor' do
      context 'with valid params' do
        it 'returns a successful response' do
          job_offer = create :job_offer
          administrator = create :administrator

          valid_attributes = {
            id: job_offer.to_param,
            email: administrator.email,
            role: 'employer'
          }

          post :add_actor, params: valid_attributes

          expect(response).to be_successful
        end

        it 'renders the actor widget with an existing user' do
          job_offer = create :job_offer
          administrator = create :administrator

          valid_attributes = {
            id: job_offer.to_param,
            email: administrator.email,
            role: 'employer'
          }

          post :add_actor, params: valid_attributes

          expect(subject).to render_template(:add_actor)
        end

        it 'returns a successful response with a non existing user' do
          job_offer = create :job_offer

          valid_attributes = {
            id: job_offer.to_param,
            email: 'non-existing@user.fr',
            role: 'employer'
          }

          post :add_actor, params: valid_attributes

          expect(response).to be_successful
        end

        it 'renders the actor widget with a non existing user' do
          job_offer = create :job_offer

          valid_attributes = {
            id: job_offer.to_param,
            email: 'non-existing@user.fr',
            role: 'employer'
          }

          post :add_actor, params: valid_attributes

          expect(subject).to render_template(:add_actor)
        end
      end

      context 'with invalid params' do
        it 'returns a non successful response' do
          job_offer = create :job_offer

          invalid_attributes = {
            id: job_offer.to_param,
            email: 'pipo'
          }

          post :add_actor, params: invalid_attributes

          expect(response).to_not be_successful
        end

        it 'returns a json filled with errors' do
          job_offer = create :job_offer

          invalid_attributes = {
            id: job_offer.to_param,
            email: 'pipo'
          }

          post :add_actor, params: invalid_attributes

          parsed_body = JSON.parse(response.body)

          expect(parsed_body.keys).to eq(['email'])
        end
      end
    end

    describe 'PUT #update' do
      context 'with valid params' do
        let(:new_attributes) do
          { title: 'PIPO' }
        end

        it 'updates the requested job_offer' do
          job_offer = create :job_offer
          put :update, params: { id: job_offer.to_param, job_offer: new_attributes }
          job_offer.reload
          expect(job_offer.title).to eq('PIPO')
        end

        it 'redirects to job offers listing' do
          job_offer = create :job_offer
          put :update, params: { id: job_offer.to_param, job_offer: valid_attributes }
          expect(response).to redirect_to(%i[admin job_offers])
        end
      end

      context 'with invalid params' do
        it "returns a success response (i.e. to display the 'edit' template)" do
          job_offer = create :job_offer
          put :update, params: { id: job_offer.to_param, job_offer: invalid_attributes }
          expect(response).to be_successful
        end
      end
    end

    describe 'DELETE #destroy' do
      it 'destroys the requested job_offer' do
        job_offer = create :job_offer
        expect do
          delete :destroy, params: { id: job_offer.to_param }
        end.to change(JobOffer, :count).by(-1)
      end

      it 'redirects to the job_offers list' do
        job_offer = create :job_offer
        delete :destroy, params: { id: job_offer.to_param }
        expect(response).to redirect_to(job_offers_url)
      end
    end
  end

  context 'when logged in as Grand Employeur administrator' do
    login_grand_employer

    describe 'GET #index' do
      it 'returns a success response' do
        create_list :job_offer, 5
        get :index, params: {}
        expect(response).to be_successful
      end
    end

    describe 'GET #archived' do
      it 'returns a success response' do
        create_list :job_offer, 5
        get :archived, params: {}
        expect(response).to be_successful
        expect(assigns(:job_offers_archived).size).to eq(0)

        create_list(:job_offer,
                    3,
                    state: :archived,
                    job_offer_actors_attributes: [{
                      administrator_id: subject.current_administrator.id,
                      role: :grand_employer
                    }])
        get :archived, params: {}
        expect(response).to be_successful
        expect(assigns(:job_offers_archived).size).to eq(3)
      end
    end

    describe 'GET #board' do
      it 'returns a success response' do
        attrs = [{
          administrator_id: subject.current_administrator.id,
          role: :grand_employer
        }]
        job_offer = create :job_offer, job_offer_actors_attributes: attrs
        get :board, params: { id: job_offer.to_param }
        expect(response).to be_successful
      end
    end

    describe 'GET #stats' do
      it 'returns a success response' do
        attrs = [{
          administrator_id: subject.current_administrator.id,
          role: :grand_employer
        }]
        job_offer = create :job_offer, job_offer_actors_attributes: attrs
        get :stats, params: { id: job_offer.to_param }
        expect(response).to be_successful
      end
    end
  end
end
