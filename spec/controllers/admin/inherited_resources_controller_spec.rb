# frozen_string_literal: true

require "rails_helper"

# The concrete subclasses of Admin::InheritedResourcesController override the
# create/update/destroy actions, so the base implementations are exercised here
# by stubbing the inherited_resources delegators (create!/update!/destroy!).
RSpec.describe Admin::InheritedResourcesController, type: :controller do
  subject(:controller_instance) { described_class.new }

  let(:administrator) { build(:administrator) }

  describe "#create" do
    context "when the resource has an administrator_id attribute" do
      subject(:create_action) { controller_instance.create }

      let(:resource) { build(:preferred_users_list, administrator: nil) }

      before { stub_action("preferred_users_lists", :create!, resource) }

      it { expect { create_action }.to change(resource, :administrator).to(administrator) }
    end

    context "when the resource has no administrator_id attribute" do
      subject(:create_action) { controller_instance.create }

      let(:resource) { build(:category) }

      before { stub_action("categories", :create!, resource) }

      it { expect { create_action }.not_to raise_error }
    end
  end

  describe "#update" do
    subject(:notice) { capture_delegator_notice("preferred_users_lists", :update!) { controller_instance.update } }

    let(:resource) { build(:preferred_users_list) }

    it { is_expected.to eq("Liste mise à jour !") }
  end

  describe "#destroy" do
    subject(:notice) { capture_delegator_notice("preferred_users_lists", :destroy!) { controller_instance.destroy } }

    let(:resource) { build(:preferred_users_list) }

    it { is_expected.to eq("Liste supprimée !") }
  end

  describe "#permitted_fields" do
    subject(:permitted_fields) { controller_instance.send(:permitted_fields) }

    it { is_expected.to eq(%i[name]) }
  end

  private

  # rubocop:disable RSpec/SubjectStub -- the action methods under test delegate
  # to inherited_resources helpers (create!/update!/destroy!) that must be
  # stubbed on the controller instance itself.
  def stub_action(controller_name, delegator, resource)
    without_partial_double_verification do
      allow(controller_instance).to receive_messages(
        controller_name:,
        current_administrator: administrator,
        resource:
      )
      allow(controller_instance).to receive(delegator)
    end
  end

  def capture_delegator_notice(controller_name, delegator)
    captured = nil
    without_partial_double_verification do
      allow(controller_instance).to receive_messages(controller_name:, resource:)
      allow(controller_instance).to receive(delegator) { |notice:| captured = notice }
    end
    yield
    captured
  end
  # rubocop:enable RSpec/SubjectStub
end
