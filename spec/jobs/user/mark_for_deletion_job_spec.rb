require "rails_helper"

RSpec.describe User::MarkForDeletionJob do
  subject(:mark_for_deletion) { described_class.new.perform }

  before do
    allow(User).to receive(:mark_for_deletion)
    mark_for_deletion
  end

  it { expect(User).to have_received(:mark_for_deletion) }
end
