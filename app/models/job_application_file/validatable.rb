module JobApplicationFile::Validatable
  extend ActiveSupport::Concern

  def mark_as_valid!(administrator)
    unless job_application_file_type.can_validate?(administrator)
      errors.add(:base, :not_authorized_to_validate)
      return false
    end

    update_column :is_validated, 1 # rubocop:disable Rails/SkipsModelValidations
    job_application.compute_notifications_counter!
  end

  def mark_as_invalid!(administrator)
    unless job_application_file_type.can_validate?(administrator)
      errors.add(:base, :not_authorized_to_validate)
      return false
    end

    update_column :is_validated, 2 # rubocop:disable Rails/SkipsModelValidations
    job_application.compute_notifications_counter!
  end

  def validated?
    is_validated == 1
  end

  def rejected?
    is_validated == 2
  end

  def waiting_validation?
    is_validated == 0
  end
end
