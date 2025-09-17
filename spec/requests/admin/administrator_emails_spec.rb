require "rails_helper"

describe Admin::AdministratorEmailsController do
  let(:administrator) { create(:administrator) }

  before { sign_in administrator }

  describe "GET #index" do
    subject(:index) { get admin_administrator_emails_path, params: {q: "administrator"}, as: :turbo_stream }

    before { index }

    it { expect(response).to be_successful }

    it { expect(response).to render_template(:index) }
  end
end
