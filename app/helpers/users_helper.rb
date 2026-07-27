# frozen_string_literal: true

module UsersHelper
  def image_user_tag(photo, options = nil)
    options ||= {}
    options.symbolize_keys!

    width = options[:width]
    height = options[:height]
    width ||= height
    height ||= width

    klasses = %w[rounded-circle]
    klasses << "w-#{width}"
    klasses << "h-#{height}"
    if options[:class].is_a?(Array)
      klasses += options[:class]
    else
      klasses << options[:class]
    end

    image_tag(image_user_url(photo), class: klasses)
  end

  def image_user_url(photo)
    return blank_photo if photo.blank?
    return account_user_photo_path if current_user&.photo

    if current_administrator && photo.model.is_a?(User)
      photo_admin_user_path(photo.model)
    elsif current_administrator && photo.model.is_a?(Administrator)
      photo_admin_account_path(id: photo.model.id)
    else
      blank_photo
    end
  rescue NoMethodError, URI::InvalidURIError, Excon::Error::Socket
    blank_photo
  end

  def blank_photo
    asset_path("default_user_avatar.svg")
  end

  def file_hint(job_application_file)
    if job_application_file.job_application_file_type.applicant_provided?
      applicant_kind_file_hint(job_application_file, file_link(job_application_file))
    else
      not_applicant_kind_file_hint(file_link(job_application_file))
    end
  end

  private

  def applicant_kind_file_hint(job_application_file, link)
    if job_application_file.is_validated == 1
      "<span class=\"valid-text\">Ce #{link} a été validé !</span>".html_safe # rubocop:disable Rails/OutputSafety
    elsif job_application_file.is_validated == 2
      "<span class=\"error-text\">Votre #{link} n'est pas valide, veuillez en téléverser un nouveau.</span>".html_safe # rubocop:disable Rails/OutputSafety
    elsif job_application_file.document_content.present?
      "<span class=\"font-weight-bold\">Vous avez déjà téléversé ce #{link}</span>, il est en attente de validation.
      <br/>Pour téléverser une nouvelle version, vous pouvez utiliser la zone ci-dessous.".html_safe # rubocop:disable Rails/OutputSafety
    end
  end

  def not_applicant_kind_file_hint(link)
    "<span class=\"font-weight-bold\">Ce #{link}</span> a été téléversé par un tiers.".html_safe # rubocop:disable Rails/OutputSafety
  end

  def file_link(job_application_file)
    link_to(
      "fichier",
      [:account, job_application_file.job_application, job_application_file, {format: :pdf}],
      target: "_blank",
      class: "text-dark-gray",
      rel: "noopener"
    )
  end
end
