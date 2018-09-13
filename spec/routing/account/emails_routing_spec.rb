require "rails_helper"

RSpec.describe Account::EmailsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/mon-compte/candidatures/1/emails").to route_to("account/emails#index", job_application_id: '1')
    end

    it "routes to #create" do
      expect(:post => "/mon-compte/candidatures/1/emails").to route_to("account/emails#create", job_application_id: '1')
    end
  end
end
