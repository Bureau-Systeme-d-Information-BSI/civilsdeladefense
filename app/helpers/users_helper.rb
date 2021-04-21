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
    if photo&.present?
      Rails.cache.fetch(photo.model) do
        encoded = Base64.encode64(photo.read)
        "data:#{photo.content_type};base64,#{encoded}"
      rescue NoMethodError => e
        if e.to_s == "undefined method `body' for nil:NilClass"
          asset_pack_path("images/default_user_avatar.svg")
        end
      rescue URI::InvalidURIError
        asset_pack_path("images/default_user_avatar.svg")
      end
    else
      asset_pack_path("images/default_user_avatar.svg")
    end
  end

  def hint_text_for_file(job_application, job_application_file)
    is_validated_value = job_application_file.is_validated
    file = job_application_file.content
    txt = []
    case is_validated_value
    when 1
      link = link_for_file(job_application, job_application_file)
      txt << "Vous pouvez #{link_to "consulter", link, target: "_blank", class: "text-dark-gray"} ce fichier.".html_safe
    when 2
      link = link_for_file(job_application, job_application_file)
      link_text = link_to "fichier", link, target: "_blank", class: "text-dark-gray"
      txt << "Votre #{link_text} n'est pas valide, veuillez en téléverser un nouveau.".html_safe
      txt << "Seuls les fichiers PDF de taille inférieure à 2Mo sont acceptés."
    else
      if file.present?
        link = link_for_file(job_application, job_application_file)
        link_text = link_to "fichier", link, target: "_blank", class: "text-dark-gray"
        txt << "Vous avez déjà téléversé ce #{link_text}, il est en attente de validation.".html_safe
        txt << 'Pour téléverser une nouvelle version,
                vous pouvez utiliser la zone ci-dessus.'.html_safe
      end
      txt << "Seuls les fichiers PDF de taille inférieure à 2Mo sont acceptés."
    end
    txt.join("<br/>").html_safe
  end

  def link_for_file(job_application, job_application_file)
    [:account, job_application, job_application_file, {format: :pdf}]
  end
end
