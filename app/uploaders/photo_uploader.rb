# frozen_string_literal: true

class PhotoUploader < CommonUploader
  include CarrierWave::MiniMagick

  version :small do
    process resize_to_fill: [64, 64]
  end

  version :medium do
    process resize_to_fill: [80, 80]
  end

  version :big do
    process resize_to_fill: [160, 160]
  end

  def content_type_whitelist
    %r{image/}
  end
end
