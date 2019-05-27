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

    image_tag image_user_url(photo, options[:width]), class: klasses
  end

  def image_user_url(photo, width)
    if photo&.present?
      style = image_user_style(width)
      photo.url(style)
    else
      asset_pack_path('images/default_user_avatar.svg')
    end
  end

  def image_user_style(width)
    case width
    when 32
      :small
    when 40
      :medium
    when 80
      :big
    end
  end

  def hint_text_for_file(job_application, job_application_file)
    is_validated_value = job_application_file.is_validated
    file = job_application_file.content
    txt = []
    if is_validated_value == 1
      link = link_for_file(job_application, job_application_file)
      txt << "Vous pouvez #{link_to 'consulter', link, target: '_blank', class: 'text-dark-gray'} ce fichier.".html_safe
    elsif is_validated_value == 2
      link = link_for_file(job_application, job_application_file)
      link_text = link_to 'fichier', link, target: '_blank', class: 'text-dark-gray'
      txt << "Votre #{link_text} n'est pas valide, veuillez en téléverser un nouveau.".html_safe
      txt << 'Seuls les fichiers PDF de taille inférieure à 2Mo sont acceptés.'
    else
      if file.present?
        link = link_for_file(job_application, job_application_file)
        link_text = link_to 'fichier', link, target: '_blank', class: 'text-dark-gray'
        txt << "Vous avez déjà téléversé ce #{link_text}, il est en attente de validation.".html_safe
        txt << 'Pour téléverser une nouvelle version,
                vous pouvez utiliser la zone ci-dessus.'.html_safe
      end
      txt << 'Seuls les fichiers PDF de taille inférieure à 2Mo sont acceptés.'
    end
    txt.join('<br/>').html_safe
  end

  def link_for_file(job_application, job_application_file)
    [:account, job_application, job_application_file, { format: :pdf }]
  end
end
