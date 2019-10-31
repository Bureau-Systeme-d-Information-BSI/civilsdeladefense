# frozen_string_literal: true

class LogoUploader < CommonUploader
  def content_type_whitelist
    %r{image/}
  end
end
