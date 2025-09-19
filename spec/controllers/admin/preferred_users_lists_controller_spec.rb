# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::PreferredUsersListsController do
  context "when logged in as 'admin' administrator" do
    login_admin

    let(:valid_attributes) do
      build(:preferred_users_list).attributes
    end

    let(:invalid_attributes) do
      {name: ""}
    end

    describe "POST #create" do
      context "with valid params" do
        it "creates a new PreferredUsersList" do
          expect {
            post :create, params: {preferred_users_list: valid_attributes}
          }.to change(PreferredUsersList, :count).by(1)
        end

        it "redirects to the created preferred_users_list" do
          post :create, params: {preferred_users_list: valid_attributes}
          expect(response).to have_http_status(:found)
        end
      end

      context "with invalid params" do
        it "returns a success response (i.e. to display the 'new' template)" do
          post :create, params: {preferred_users_list: invalid_attributes}
          expect(response).not_to be_successful
        end
      end
    end
  end

  context "when logged in as Employeur administrator" do
    login_employer

    # This should return the minimal set of attributes required to create a valid
    # PreferredUsersList. As you add validations to PreferredUsersList, be sure to
    # adjust the attributes here as well.
    let(:valid_attributes) do
      build(:preferred_users_list).attributes
    end

    describe "POST #create" do
      context "with valid params" do
        it "creates a new PreferredUsersList" do
          expect {
            post :create, params: {preferred_users_list: valid_attributes}
          }.to change(PreferredUsersList, :count).by(1)
        end
      end
    end
  end
end
