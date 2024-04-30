require "rails_helper"

RSpec.describe BookmarksController do
  describe "Adding a bookmark" do
    subject(:create_request) { post bookmarks_path(job_offer.id), as: :turbo_stream }

    let(:job_offer) { create(:job_offer) }

    context "when user is authenticated" do
      let(:user) { create(:confirmed_user) }

      before { sign_in user }

      it { expect { create_request }.to change { user.bookmarks.count }.by(1) }

      describe "response" do
        before { create_request }

        it { expect(response).to have_http_status(:ok) }
      end
    end

    context "when user is not authenticated" do
      it { expect { create_request }.not_to change(Bookmark, :count) }

      it { expect(create_request).to redirect_to(new_user_session_path) }
    end
  end

  describe "Removing a bookmark" do
    subject(:destroy_request) { delete bookmark_path(bookmark.job_offer_id), as: :turbo_stream }

    let!(:bookmark) { create(:bookmark) }

    context "when user is authenticated" do
      let(:user) { bookmark.user }

      before { sign_in user }

      it { expect { destroy_request }.to change { user.bookmarks.count }.by(-1) }

      describe "response" do
        before { destroy_request }

        it { expect(response).to have_http_status(:ok) }
      end
    end

    context "when user is not authenticated" do
      it { expect { destroy_request }.not_to change(Bookmark, :count) }

      it { expect(destroy_request).to redirect_to(new_user_session_path) }
    end
  end
end
