require "rails_helper"

RSpec.describe User::DeleteOldJob do
  subject(:delete_old) { described_class.new.perform }

  before do
    allow(User).to receive(:destroy_when_too_old)
    delete_old
  end

  it { expect(User).to have_received(:destroy_when_too_old) }
end
