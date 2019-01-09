class JobOfferActor < ApplicationRecord
  belongs_to :job_offer, inverse_of: :job_offer_actors
  belongs_to :administrator

  accepts_nested_attributes_for :administrator, allow_destroy: true

  def administrator_attributes=(attributes)
    to_be_destroyed = attributes.delete(:_destroy)
    existing = if attributes[:id].present?
      Administrator.find attributes[:id]
    else
      Administrator.where(email: attributes[:email]).first
    end
    if existing
      self.administrator = existing
    else
      a = build_administrator(attributes)
      a.inviter = self.job_offer&.owner
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
    brh: 30
  }
end
