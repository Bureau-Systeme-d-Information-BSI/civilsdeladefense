# frozen_string_literal: true

# Represents people that should have write or read rights on a job offer and its depending applications
class JobOfferActor < ApplicationRecord
  belongs_to :job_offer, inverse_of: :job_offer_actors
  belongs_to :administrator

  accepts_nested_attributes_for :administrator

  def administrator_attributes=(attributes)
    mark_for_destruction if has_destroy_flag?(attributes)

    administrator = search_administrator_in_attributes(attributes)

    if administrator
      self.administrator = administrator
    else
      build_administrator(
        attributes.except("_destroy").merge(inviter: job_offer&.owner)
      )
    end
  end

  validates :role, presence: true

  #####################################
  # Enums
  enum role: {
    employer: 0,
    grand_employer: 10,
    supervisor_employer: 20,
    brh: 30,
    cmg: 40
  }

  private

  def search_administrator_in_attributes(attributes)
    if attributes[:id].present?
      Administrator.find(attributes[:id])
    else
      Administrator.find_by(email: attributes[:email])
    end
  end
end
