class JobOffer < ApplicationRecord
  belongs_to :owner, class_name: 'Admin'
  belongs_to :category
  belongs_to :official_status
  belongs_to :employer
  belongs_to :contract_type
  belongs_to :study_level
  belongs_to :experience_level
  belongs_to :sector

  validates :title, :description, presence: true

  OPTIONS_AVAILABLE = { disabled: 0, optional: 1, mandatory: 2 }

  enum option_cover_letter: OPTIONS_AVAILABLE, _suffix: true
  enum option_resume: OPTIONS_AVAILABLE, _suffix: true
  enum option_portfolio: OPTIONS_AVAILABLE, _suffix: true
  enum option_photo: OPTIONS_AVAILABLE, _suffix: true
  enum option_website_url: OPTIONS_AVAILABLE, _suffix: true
  enum option_linkedin_url: OPTIONS_AVAILABLE, _suffix: true
end
