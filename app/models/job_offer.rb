class JobOffer < ApplicationRecord
  include AASM

  extend FriendlyId
  friendly_id :title, use: [:slugged, :finders, :history]

  belongs_to :owner, class_name: 'Administrator'
  belongs_to :category
  belongs_to :official_status
  belongs_to :employer
  belongs_to :contract_type
  belongs_to :study_level
  belongs_to :experience_level
  belongs_to :sector

  has_many :job_applications

  validates :title, :description, presence: true

  OPTIONS_AVAILABLE = { disabled: 0, optional: 1, mandatory: 2 }
  FILES = %i(cover_letter resume photo)
  URLS = %i(portfolio_url website_url linkedin_url)
  (FILES + URLS).each do |opt_name|
    enum :"option_#{opt_name}" => OPTIONS_AVAILABLE, _suffix: true
  end

  enum state: {
    draft: 0,
    published: 1,
    suspended: 2,
    archived: 3
  }

  aasm column: :state, enum: true do
    state :draft, initial: true
    state :published
    state :suspended
    state :archived

    event :publish do
      transitions from: [:draft], to: :published
    end

    event :draftize do
      transitions from: [:published], to: :draft
    end

    event :archive do
      transitions from: [:draft, :published, :suspended], to: :archived
    end

    event :suspend do
      transitions from: [:published], to: :suspended
    end

    event :unsuspend do
      transitions from: [:suspended], to: :published
    end

    event :unarchive do
      transitions from: [:archived], to: :draft
    end
  end
end
