# frozen_string_literal: true

# User personal information like gender, birthdate, etc.
class PersonalProfile < ApplicationRecord
  belongs_to :personal_profileable, polymorphic: true
  belongs_to :study_level, optional: true
  belongs_to :experience_level, optional: true

  attr_writer :address

  #####################################
  # Enums
  enum gender: {
    female: 1,
    male: 2,
    other: 3
  }

  after_save :datalake_to_job_applications,
             if: proc { |profile| profile.personal_profileable_type == 'User' }

  def datalake_to_job_applications
    attributes_filtered = attributes.except('id',
                                            'personal_profileable_type',
                                            'personal_profileable_id',
                                            'created_at',
                                            'updated_at')

    personal_profileable.job_applications_active.each do |job_application|
      if job_application.personal_profile.nil?
        job_application.create_personal_profile(attributes_filtered)
      else
        job_application.personal_profile.update_attributes(attributes_filtered)
      end
    end
  end

  def address
    c = ISO3166::Country.new(country)
    real_country = c && c.translations[I18n.locale.to_s]
    ary = [address_1]
    ary << "#{postcode} #{city}, #{real_country}"
    @address = ary.join(' ').html_safe
  end
end
