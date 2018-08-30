module UsersHelper
  def image_user_tag(photo, options = nil)
    options ||= {}
    options.symbolize_keys!

    width = options[:width]
    height = options[:height]
    width ||= height
    height ||= width

    klasses = %w(rounded-circle)
    klasses << "w-#{ width }"
    klasses << "h-#{ height }"
    if options[:class].is_a?(Array)
      klasses += options[:class]
    else
      klasses << options[:class]
    end

    image_url = if photo.attached?
      extent = [width*2, height*2].join('x')
      resize =  extent + '^'
      photo.variant(resize: resize, gravity: :center, extent: extent)
    else
      asset_pack_path('images/default_user_avatar.svg')
    end

    image_tag image_url, class: klasses
  end
end
