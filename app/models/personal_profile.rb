# frozen_string_literal: true

# User personal information like gender, birthdate, etc.
class PersonalProfile < ApplicationRecord
  belongs_to :personal_profileable, polymorphic: true
  belongs_to :study_level, optional: true
  belongs_to :experience_level, optional: true

  #####################################
  # Validations

  validates :current_position,
            :phone,
            :address_1,
            :postcode,
            :city,
            :country,
            presence: true

  attr_writer :address

  #####################################
  # Enums
  enum gender: {
    female: 1,
    male: 2,
    other: 3
  }

  def datalake_attributes
    attributes.except('id',
                      'personal_profileable_type',
                      'personal_profileable_id',
                      'created_at',
                      'updated_at')
  end

  def datalake_to_job_application_profiles!(options = {})
    relation = personal_profileable.job_applications_active

    if (except = options.delete(:except))
      relation = relation.where.not('job_applications.id = ?', except)
    end

    relation.each do |job_application|
      if job_application.personal_profile.nil?
        job_application.create_personal_profile(datalake_attributes)
      else
        job_application.personal_profile.update_attributes(datalake_attributes)
      end
    end
  end

  def datalake_to_user_profile!
    user = personal_profileable.user
    if user.personal_profile.nil?
      user.create_personal_profile(datalake_attributes)
    else
      user.personal_profile.update_attributes(datalake_attributes)
    end
  end

  def address
    c = ISO3166::Country.new(country)
    real_country = c && c.translations[I18n.locale.to_s]
    ary = [address_1]
    ary << "#{postcode} #{city}, #{real_country}"
    @address = ary.join(' ').html_safe
  end

  def address_short
    ary = []
    ary << city if city.present?
    ary << country if country.present?
    ary.join(' ')
  end
end
