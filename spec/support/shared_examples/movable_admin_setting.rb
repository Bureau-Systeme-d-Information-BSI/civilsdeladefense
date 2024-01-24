# frozen_string_literal: true

RSpec.shared_examples "a movable admin setting" do |class_name|
  let(:setting) { create(class_name) }
  let(:plural) { class_name.to_s.pluralize }
  let(:index_path) { send(:"admin_settings_#{plural}_path") }
  before { sign_in create(:administrator) }

  describe "moving the #{class_name} setting higher" do
    subject(:move_higher_request) {
      post send(:"move_higher_admin_settings_#{class_name}_path", setting)
    }

    before {
      create(class_name)
      setting.move_to_bottom
    }

    it "redirects to index" do
      expect(move_higher_request).to redirect_to(index_path)
    end

    it "moves the #{class_name} setting higher" do
      expect { move_higher_request }.to change { setting.reload.position }.by(-1)
    end
  end

  describe "moving the #{class_name} setting lower" do
    subject(:move_lower_request) {
      post send(:"move_lower_admin_settings_#{class_name}_path", setting)
    }

    before {
      create(class_name)
      setting.move_to_top
    }

    it "redirects to index" do
      expect(move_lower_request).to redirect_to(index_path)
    end

    it "moves the #{class_name} setting lower" do
      expect { move_lower_request }.to change { setting.reload.position }.by(1)
    end
  end
end
