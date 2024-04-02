# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::JobOffersController do
  context "when logged in as 'admin' administrator" do
    login_admin

    let(:valid_attributes) do
      hsh = build(:job_offer).attributes
      hsh[:employer_id] = create(:employer).id
      hsh[:category_id] = create(:category).id
      hsh
    end

    let(:invalid_attributes) do
      {title: ""}
    end

    describe "GET #index" do
      it "returns a success response" do
        JobOffer.destroy_all
        create_list(:job_offer, 5)
        get :index, params: {}
        expect(response).to be_successful
        expect(assigns(:job_offers_active).size).to eq(5)
      end
    end

    describe "GET #archived" do
      it "returns a success response" do
        create_list(:job_offer, 5)
        create_list(:job_offer, 3, state: :archived)
        get :archived, params: {}
        expect(response).to be_successful
        expect(assigns(:job_offers_archived).size).to eq(3)
      end
    end

    describe "GET #show" do
      it "returns a success response" do
        job_offer = create(:job_offer)
        get :show, params: {id: job_offer.to_param}
        expect(response).to be_successful
      end
    end

    describe "GET #board" do
      it "returns a success response" do
        job_offer = create(:job_offer)
        get :board, params: {id: job_offer.to_param}
        expect(response).to be_successful
      end
    end

    describe "GET #stats" do
      it "returns a success response" do
        job_offer = create(:job_offer)
        get :stats, params: {id: job_offer.to_param}
        expect(response).to be_successful
      end
    end

    describe "GET #new" do
      it "returns a success response" do
        get :new, params: {}
        expect(response).to be_successful
      end
    end

    describe "GET #edit" do
      it "returns a success response" do
        job_offer = create(:job_offer)
        get :edit, params: {id: job_offer.to_param}
        expect(response).to be_successful
      end
    end

    describe "POST #create" do
      context "with valid params" do
        it "creates a new JobOffer" do
          expect {
            post :create, params: {job_offer: valid_attributes}
          }.to change(JobOffer, :count).by(1)
        end

        it "redirects to the created job_offer" do
          post :create, params: {job_offer: valid_attributes}
          expect(response).to redirect_to(%i[admin job_offers])
        end
      end

      context "with invalid params" do
        it "returns a success response (i.e. to display the 'new' template)" do
          post :create, params: {job_offer: invalid_attributes}
          expect(response).to be_successful
        end
      end
    end

    describe "POST #create_and_publish" do
      context "with valid params" do
        it "create_and_publish a new JobOffer" do
          expect {
            post :create_and_publish, params: {job_offer: valid_attributes}
          }.to change(JobOffer, :count).by(1)
        end

        it "redirects to the created job_offer" do
          post :create_and_publish, params: {job_offer: valid_attributes}
          expect(response).to redirect_to(%i[admin job_offers])
        end

        it "set published_at" do
          post :create_and_publish, params: {job_offer: valid_attributes}
          expect(JobOffer.order(:created_at).first.published_at.present?).to be(true)
        end
      end

      context "with invalid params" do
        it "returns a success response (i.e. to display the 'new' template)" do
          post :create_and_publish, params: {job_offer: invalid_attributes}
          expect(response).to be_successful
        end
      end
    end

    describe "POST #add_actor" do
      context "with valid params" do
        it "returns a successful response" do
          job_offer = create(:job_offer)
          administrator = create(:administrator)

          valid_attributes = {
            id: job_offer.to_param,
            email: administrator.email,
            role: "employer"
          }

          post :add_actor, params: valid_attributes

          expect(response).to be_successful
        end

        it "returns a successful response even with upcase char" do
          job_offer = create(:job_offer)
          administrator = create(:administrator)

          valid_attributes = {
            id: job_offer.to_param,
            email: administrator.email.upcase,
            role: "employer"
          }

          post :add_actor, params: valid_attributes

          expect(response).to be_successful
        end

        it "renders the actor widget with an existing user" do
          job_offer = create(:job_offer)
          administrator = create(:administrator)

          valid_attributes = {
            id: job_offer.to_param,
            email: administrator.email,
            role: "employer"
          }

          post :add_actor, params: valid_attributes

          expect(subject).to render_template(:add_actor) # rubocop:disable RSpec/NamedSubject
        end

        it "returns a successful response with a non existing user" do
          job_offer = create(:job_offer)

          valid_attributes = {
            id: job_offer.to_param,
            email: "non-existing@user.fr",
            role: "employer"
          }

          post :add_actor, params: valid_attributes

          expect(response).to be_successful
        end

        it "renders the actor widget with a non existing user" do
          job_offer = create(:job_offer)

          valid_attributes = {
            id: job_offer.to_param,
            email: "non-existing@user.fr",
            role: "employer"
          }

          post :add_actor, params: valid_attributes

          expect(subject).to render_template(:add_actor) # rubocop:disable RSpec/NamedSubject
        end
      end

      context "with invalid params" do
        it "returns a non successful response" do
          job_offer = create(:job_offer)

          invalid_attributes = {
            id: job_offer.to_param,
            email: "pipo"
          }

          post :add_actor, params: invalid_attributes

          expect(response).not_to be_successful
        end

        it "returns a json filled with errors" do
          job_offer = create(:job_offer)

          invalid_attributes = {
            id: job_offer.to_param,
            email: "pipo"
          }

          post :add_actor, params: invalid_attributes

          parsed_body = response.parsed_body

          expect(parsed_body.keys).to eq(["email"])
        end
      end
    end

    describe "PUT #update" do
      context "with valid params" do
        let(:new_attributes) do
          {title: "PIPO F/H"}
        end

        it "updates the requested job_offer" do
          job_offer = create(:job_offer)
          put :update, params: {id: job_offer.to_param, job_offer: new_attributes}
          job_offer.reload
          expect(job_offer.title).to eq("PIPO F/H")
        end

        it "redirects to job offers listing" do
          job_offer = create(:job_offer)
          put :update, params: {id: job_offer.to_param, job_offer: valid_attributes}
          expect(response).to redirect_to(%i[admin job_offers])
        end
      end

      context "with invalid params" do
        it "returns a success response (i.e. to display the 'edit' template)" do
          job_offer = create(:job_offer)
          put :update, params: {id: job_offer.to_param, job_offer: invalid_attributes}
          expect(response).to be_successful
        end
      end
    end

    describe "DELETE #destroy" do
      it "destroys the requested job_offer" do
        job_offer = create(:job_offer)
        expect {
          delete :destroy, params: {id: job_offer.to_param}
        }.to change(JobOffer, :count).by(-1)
      end

      it "redirects to the job_offers list" do
        job_offer = create(:job_offer)
        delete :destroy, params: {id: job_offer.to_param}
        expect(response).to redirect_to(job_offers_url)
      end
    end
  end

  context "when logged in as Grand Employeur administrator" do
    login_grand_employer

    describe "GET #index" do
      it "returns a success response" do
        create_list(:job_offer, 5)
        get :index, params: {}
        expect(response).to be_successful
      end
    end

    describe "GET #archived" do
      it "returns a success response" do
        create_list(:job_offer, 5)
        get :archived, params: {}
        expect(response).to be_successful
        expect(assigns(:job_offers_archived).size).to eq(0)

        create_list(:job_offer,
          3,
          state: :archived,
          job_offer_actors_attributes: [{
            administrator_id: subject.current_administrator.id, # rubocop:disable RSpec/NamedSubject
            role: :grand_employer
          }])
        get :archived, params: {}
        expect(response).to be_successful
        expect(assigns(:job_offers_archived).size).to eq(3)
      end
    end

    describe "GET #board" do
      it "returns a success response" do
        attrs = [{
          administrator_id: subject.current_administrator.id, # rubocop:disable RSpec/NamedSubject
          role: :grand_employer
        }]
        job_offer = create(:job_offer, job_offer_actors_attributes: attrs)
        get :board, params: {id: job_offer.to_param}
        expect(response).to be_successful
      end
    end

    describe "GET #stats" do
      it "returns a success response" do
        attrs = [{
          administrator_id: subject.current_administrator.id, # rubocop:disable RSpec/NamedSubject
          role: :grand_employer
        }]
        job_offer = create(:job_offer, job_offer_actors_attributes: attrs)
        get :stats, params: {id: job_offer.to_param}
        expect(response).to be_successful
      end
    end
  end
end
