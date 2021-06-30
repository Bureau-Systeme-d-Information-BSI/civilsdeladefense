class RemoveBenefitIdFromJobOffer < ActiveRecord::Migration[6.1]
  def change
    remove_reference :job_offers, :benefit, type: :uuid
  end
end
