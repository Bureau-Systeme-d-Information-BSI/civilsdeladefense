require "rails_helper"

RSpec.describe JobApplication::Preselectable do
  describe "#preselect_as_favorite!" do
    subject(:preselect_as_favorite) { job_application.preselect_as_favorite! }

    let(:job_application) { create(:job_application) }

    it { expect { preselect_as_favorite }.to change(job_application, :preselection).to("favorite") }
  end

  describe "#unpreselect_as_favorite!" do
    subject(:unpreselect_as_favorite) { job_application.unpreselect_as_favorite! }

    let(:job_application) { create(:job_application, preselection: :favorite) }

    it { expect { unpreselect_as_favorite }.to change(job_application, :preselection).to("pending") }
  end

  describe "#preselect_as_unfavorite!" do
    subject(:preselect_as_unfavorite) { job_application.preselect_as_unfavorite! }

    let(:job_application) { create(:job_application) }

    it { expect { preselect_as_unfavorite }.to change(job_application, :preselection).to("unfavorite") }
  end

  describe "#unpreselect_as_unfavorite!" do
    subject(:unpreselect_as_unfavorite) { job_application.unpreselect_as_unfavorite! }

    let(:job_application) { create(:job_application, preselection: :unfavorite) }

    it { expect { unpreselect_as_unfavorite }.to change(job_application, :preselection).to("pending") }
  end
end
