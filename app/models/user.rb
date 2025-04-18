# frozen_string_literal: true

# Candidate to job offer
class User < ApplicationRecord
  self.ignored_columns += %w[gender] # Deprecated on 2024-09-03

  PASSWORD_REGEX = /^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[\\\/<>{}()#¤:;,.?!•·|"'`´~@£¨µ§²$€%^&*+=_-]).{12,70}$/

  def self.omniauth_providers
    ENV["FRANCE_CONNECT_HOST"] ? [:france_connect] : []
  end

  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable,
    :confirmable, :lockable, :timeoutable,
    :omniauthable, omniauth_providers: User.omniauth_providers
  include Suspendable
  include DeletionFlow
  include PgSearch::Model
  pg_search_scope :search_full_text, against: [:first_name, :last_name], ignoring: :accents

  belongs_to :organization

  has_one :profile, as: :profileable, required: true, dependent: :destroy

  has_many :omniauth_informations, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :job_applications, -> { order(created_at: :desc) }, dependent: :nullify, inverse_of: :user
  has_many :job_application_files, through: :job_applications
  has_many :job_offers, through: :job_applications
  has_many :preferred_users, dependent: :destroy
  has_many :preferred_users_lists, through: :preferred_users

  accepts_nested_attributes_for :profile

  phony_normalize :phone, default_country_code: "FR"

  mount_uploader :photo, PhotoUploader, mount_on: :photo_file_name

  validates :photo, file_size: {less_than: 1.megabytes}
  validates :first_name, :last_name, presence: true
  validates_plausible_phone :phone
  validates :phone, :current_position, presence: true, allow_nil: true
  validates :terms_of_service, :certify_majority, acceptance: true
  validate :password_complexity

  default_scope { order(created_at: :desc) }

  scope :concerned, ->(administrator) {
    joins(job_offers: [:administrators, :owner]).where(administrators: {id: administrator.id}).or(
      joins(job_offers: [:administrators, :owner]).where(owners_job_offers: {id: administrator.id})
    )
  }

  scope :by_category, ->(*category_ids) {
    joins(profile: :category_experience_levels)
      .where(category_experience_levels: {category_id: category_ids})
  }

  scope :by_experience_level, ->(*experience_level_ids) {
    joins(profile: :category_experience_levels)
      .where(category_experience_levels: {experience_level_id: experience_level_ids})
  }

  attr_accessor :is_deleted, :delete_photo

  before_validation :build_profile, if: -> { profile.nil? }
  before_save :remove_mark_for_deletion
  before_update :destroy_photo
  before_destroy :mark_job_applications_as_read

  def self.ransackable_scopes(auth_object = nil)
    %i[concerned by_category by_experience_level]
  end

  def full_name
    if is_deleted
      "Compte candidat supprimé"
    else
      [first_name, last_name].join(" ")
    end
  end

  def password_complexity
    return if password.blank? || password =~ PASSWORD_REGEX

    errors.add :password, :not_strong_enough
  end

  def most_advanced_job_application
    job_applications.order(state: :desc).first
  end

  def already_applied?(job_offer)
    job_applications.select(:job_offer_id).map(&:job_offer_id).include?(job_offer.id)
  end

  def job_applications_active
    job_applications.joins(:job_offer).where.not(job_offers: {state: :archived})
  end

  def link_to_omniauth?(provider: nil)
    if provider.present?
      omniauth_informations.where(provider: provider).any?
    else
      omniauth_informations.any?
    end
  end

  def last_job_application
    job_applications.order(created_at: :desc).first
  end

  def full_address
    [address, postal_code, city].compact.join(" ")
  end

  private

  def password_required?
    !link_to_omniauth? && super
  end

  def destroy_photo
    remove_photo! if delete_photo
  end

  def remove_mark_for_deletion
    self.marked_for_deletion_on = nil
  end

  def mark_job_applications_as_read
    job_applications.map(&:mark_as_read!)
  end
end

# == Schema Information
#
# Table name: users
#
#  id                               :uuid             not null, primary key
#  address                          :string
#  city                             :string
#  confirmation_sent_at             :datetime
#  confirmation_token               :string
#  confirmed_at                     :datetime
#  current_position                 :string
#  current_sign_in_at               :datetime
#  current_sign_in_ip               :inet
#  email                            :string           default(""), not null
#  encrypted_file_transfer_in_error :boolean          default(FALSE)
#  encrypted_password               :string           default(""), not null
#  failed_attempts                  :integer          default(0), not null
#  first_name                       :string
#  job_applications_count           :integer          default(0), not null
#  last_name                        :string
#  last_sign_in_at                  :datetime
#  last_sign_in_ip                  :inet
#  locked_at                        :datetime
#  marked_for_deletion_on           :date
#  phone                            :string
#  photo_content_type               :string
#  photo_file_name                  :string
#  photo_file_size                  :bigint
#  photo_is_validated               :integer          default(0)
#  photo_updated_at                 :datetime
#  postal_code                      :string
#  receive_job_offer_mails          :boolean          default(FALSE)
#  remember_created_at              :datetime
#  reset_password_sent_at           :datetime
#  reset_password_token             :string
#  sign_in_count                    :integer          default(0), not null
#  suspended_at                     :datetime
#  suspension_reason                :string
#  unconfirmed_email                :string
#  unlock_token                     :string
#  website_url                      :string
#  created_at                       :datetime         not null
#  updated_at                       :datetime         not null
#  organization_id                  :uuid
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_organization_id       (organization_id)
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_unlock_token          (unlock_token) UNIQUE
#
