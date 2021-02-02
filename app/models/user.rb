# frozen_string_literal: true

# Candidate to job offer
class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable, :omniauthable, omniauth_providers: %i[france_connect]
  include Suspendable
  include DeletionFlow
  include PgSearch::Model
  pg_search_scope :search_full_text,
                  against: %i[first_name last_name]

  belongs_to :organization
  belongs_to :last_job_application, class_name: 'JobApplication', optional: true
  has_many :france_connect_informations

  has_many :job_applications, -> { order(created_at: :desc) }, dependent: :nullify
  has_many :job_offers, through: :job_applications
  has_many :preferred_users, dependent: :destroy
  has_many :preferred_users_lists, through: :preferred_users

  mount_uploader :photo, PhotoUploader, mount_on: :photo_file_name
  validates :photo,
            file_size: { less_than: 1.megabytes }

  validates :first_name, :last_name, :phone, :current_position, presence: true
  validates :terms_of_service, :certify_majority, acceptance: true
  validate :password_complexity

  default_scope { order(created_at: :desc) }

  attr_accessor :is_deleted

  def full_name
    if is_deleted
      'Compte candidat supprimé'
    else
      [first_name, last_name].join(' ')
    end
  end

  def password_complexity
    # Regexp extracted from https://stackoverflow.com/questions/19605150/regex-for-password-must-contain-at-least-eight-characters-at-least-one-number-a
    regexp = /^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,70}$/
    return if password.blank? || password =~ regexp

    errors.add :password, :not_strong_enough
  end

  def most_advanced_job_application
    job_applications.order(state: :desc).first
  end

  def already_applied?(job_offer)
    job_applications.select(:job_offer_id).map(&:job_offer_id).include?(job_offer.id)
  end

  def job_applications_active
    job_applications.joins(:job_offer).where.not(job_offers: { state: :archived })
  end

  def link_to_france_connect?
    france_connect_informations.any?
  end

  private

  def password_required?
    !link_to_france_connect? && super
  end
end
