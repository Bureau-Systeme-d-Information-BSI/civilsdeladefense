class Notification < ApplicationRecord
  belongs_to :recipient, class_name: "Administrator"
  belongs_to :instigator, optional: true, class_name: "Administrator"
  belongs_to :job_offer
  belongs_to :job_application, optional: true

  KINDS = %w[
    job_offer_new job_offer_publish job_offer_suspend job_offer_archive
    job_application_new job_application_accepted
    job_application_contract_drafting_full job_application_contract_received
  ]
  validates :kind, inclusion: {in: KINDS}

  def self.generate(kind:, job_offer: nil, job_application: nil, instigator: nil)
    return if job_offer.blank? && job_application.blank?

    instigator ||= Current.administrator
    job_offer ||= job_application.job_offer

    administrators = concerned_administrator(job_offer)
    administrators.each do |administrator|
      create(
        kind: kind,
        instigator_id: instigator&.id,
        job_offer_id: job_offer.id,
        job_application_id: job_application&.id,
        recipient_id: administrator.id
      )
    end
  end

  def self.concerned_administrator(job_offer)
    Administrator.left_joins(:job_offers).where(role: :bant).or(
      Administrator.left_joins(:job_offers).where(job_offers: {id: job_offer.id})
    ).distinct
  end

  def self.job_application_contract_drafting_full(job_application)
    return unless job_application.contract_drafting?
    must_be_provided_files = job_application.files_to_be_provided[:must_be_provided_files]
    return unless must_be_provided_files.all?(&:validated?)

    generate(
      kind: :job_application_contract_drafting_full,
      job_application: job_application
    )
  end

  def title
    result = []
    result << "#{job_offer.identifier} #{job_offer.title}"

    if job_application.present?
      result << "- Candidat #{job_application.user.full_name}"
    end

    if instigator.present?
      result << "par #{instigator.full_name}"
    end
    result.join(" ")
  end

  def url
    if job_application.present?
      Rails.application.routes.url_helpers.admin_job_application_url(
        id: job_application.id, job_offer_id: job_offer.id
      )
    else
      Rails.application.routes.url_helpers.admin_job_offer_url(job_offer)
    end
  end
end

# == Schema Information
#
# Table name: notifications
#
#  id                 :uuid             not null, primary key
#  daily              :boolean          default(FALSE)
#  kind               :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  instigator_id      :uuid
#  job_application_id :uuid
#  job_offer_id       :uuid
#  recipient_id       :uuid             not null
#
# Indexes
#
#  index_notifications_on_instigator_id       (instigator_id)
#  index_notifications_on_job_application_id  (job_application_id)
#  index_notifications_on_job_offer_id        (job_offer_id)
#  index_notifications_on_recipient_id        (recipient_id)
#
# Foreign Keys
#
#  fk_rails_0595cf6733  (job_application_id => job_applications.id)
#  fk_rails_44e540a267  (instigator_id => administrators.id)
#  fk_rails_4aea6afa11  (recipient_id => administrators.id)
#  fk_rails_53ccaf6ba7  (job_offer_id => job_offers.id)
#
