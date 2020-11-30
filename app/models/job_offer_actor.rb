# frozen_string_literal: true

# Represents people that should have write or read rights on a job offer and its depending applications
class JobOfferActor < ApplicationRecord
  belongs_to :job_offer, inverse_of: :job_offer_actors
  belongs_to :administrator

  accepts_nested_attributes_for :administrator

  def administrator_attributes=(attributes)
    existing = nil
    existing = Administrator.find(attributes[:id]) if attributes[:id].present?
    existing ||= Administrator.where(email: attributes[:email]).first
    if existing
      if has_destroy_flag?(attributes)
        mark_for_destruction
      else
        self.administrator = existing
      end
    elsif has_destroy_flag?(attributes)
      mark_for_destruction
    else
      attributes.delete(:_destroy)
      a = build_administrator(attributes)
      a.inviter = job_offer&.owner
      a
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
end
