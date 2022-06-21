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
    return photo_account_user_path if current_user&.photo

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
    asset_pack_path("images/default_user_avatar.svg")
  end

  def hint_text_for_file(job_application, job_application_file)
    link = [:account, job_application, job_application_file, {format: :pdf}]
    fichier_text = link_to("fichier", link, target: "_blank", class: "text-dark-gray", rel: "noopener")
    if job_application_file.is_validated == 1
      "<span class=\"valid-text\">Ce #{fichier_text} a été validé !</span>".html_safe
    elsif job_application_file.is_validated == 2
      "<span class=\"error-text\">Votre #{fichier_text} n'est pas valide, veuillez en téléverser un nouveau.</span>".html_safe
    elsif job_application_file.content.present?
      "<span class=\"font-weight-bold\">Vous avez déjà téléversé ce #{fichier_text}</span>, il est en attente de validation.<br/>Pour téléverser une nouvelle version,
              vous pouvez utiliser la zone ci-dessous.".html_safe
    end
  end
end
