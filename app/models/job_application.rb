class JobApplication < ApplicationRecord
  belongs_to :job_offer
  belongs_to :user, optional: true

  JobOffer::FILES.each do |file|
    has_one_attached file.to_sym
  end

  validates :first_name, :last_name, :current_position, :phone, presence: true

  validates_acceptance_of :terms_of_service

  def full_name
    [first_name, last_name].join(" ")
  end
end
