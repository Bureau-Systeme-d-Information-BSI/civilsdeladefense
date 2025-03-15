require "rails_helper"

RSpec.describe Administrator::DeactivateOldJob do
  subject(:deactivate_old) { described_class.new.perform }

  before do
    allow(Administrator).to receive(:deactivate_when_too_old!)
    deactivate_old
  end

  it { expect(Administrator).to have_received(:deactivate_when_too_old!) }
end
