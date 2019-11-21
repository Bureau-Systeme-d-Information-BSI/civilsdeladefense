# frozen_string_literal: true

class LogoUploader < CommonUploader
  def fog_public
    true
  end

  def content_type_whitelist
    %r{image/}
  end
end
