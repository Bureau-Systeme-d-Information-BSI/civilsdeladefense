# frozen_string_literal: true

RSpec.shared_examples "an admin setting" do |class_name, attribute|
  let(:setting) { create(class_name) }
  let(:klass) { class_name.to_s.classify.constantize }
  let(:plural) { class_name.to_s.pluralize }
  let(:index_path) { send("admin_settings_#{plural}_path") }
  before { sign_in create(:administrator) }

  describe "listing the #{class_name} settings" do
    subject(:index_request) { get index_path }

    before { setting }

    it "renders the template" do
      expect(index_request).to render_template(:index)
    end

    it "lists the #{class_name} settings" do
      index_request
      expect(response).to be_successful
      expect(response.body).to include(setting.send(attribute))
    end
  end

  describe "creating a #{class_name} setting" do
    subject(:create_request) {
      post index_path, params: {class_name => attributes_for(class_name)}
    }

    it "redirects to the index page" do
      expect(create_request).to redirect_to(index_path)
    end

    it "creates a #{class_name} setting" do
      expect { create_request }.to change(klass, :count).by(1)
    end
  end

  describe "updating a #{class_name} setting" do
    subject(:update_request) {
      patch send("admin_settings_#{class_name}_path", setting), params: {class_name => {attribute => "new value"}}
    }

    it "redirects to the index page" do
      expect(update_request).to redirect_to(index_path)
    end

    it "updates the #{class_name} setting" do
      expect { update_request }.to change { setting.reload.send(attribute) }.to("new value")
    end
  end

  describe "destroying a #{class_name} setting" do
    subject(:destroy_request) {
      delete send("admin_settings_#{class_name}_path", setting)
    }

    it "redirects to the index page" do
      expect(destroy_request).to redirect_to(index_path)
    end

    it "destroys the #{class_name} setting" do
      destroy_request
      expect { setting.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
