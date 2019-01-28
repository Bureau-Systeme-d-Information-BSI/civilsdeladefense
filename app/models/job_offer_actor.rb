class JobOfferActor < ApplicationRecord
  belongs_to :job_offer, inverse_of: :job_offer_actors
  belongs_to :administrator

  accepts_nested_attributes_for :administrator

  def administrator_attributes=(attributes)
    existing = if attributes[:id].present?
      Administrator.find attributes[:id]
    else
      Administrator.where(email: attributes[:email]).first
    end
    if existing
      if has_destroy_flag?(attributes)
        self.mark_for_destruction
      else
        self.administrator = existing
      end
    else
      unless has_destroy_flag?(attributes)
        attributes.delete(:_destroy)
        a = build_administrator(attributes)
        a.inviter = self.job_offer&.owner
        a
      end
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
