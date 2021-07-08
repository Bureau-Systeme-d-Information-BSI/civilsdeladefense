# frozen_string_literal: true

class LogoUploader < CommonUploader
  def fog_public
    true
  end

  def content_type_allowlist
    %r{image/}
  end
end
