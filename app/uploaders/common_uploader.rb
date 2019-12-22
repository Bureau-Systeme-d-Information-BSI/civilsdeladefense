# frozen_string_literal: true

class CommonUploader < CarrierWave::Uploader::Base
  include CarrierWave::Compatibility::Paperclip

  def paperclip_path
    self.class.mappings[:id_partition] = ->(u, _f) { u.model.id.scan(/.{3}/).first(3).join('/') }
    self.class.mappings[:class] = lambda do |u, _f|
      u.model.class.name.underscore.pluralize.gsub('legacy_uploader/', '')
    end
    fog = 'CarrierWave::Storage::Fog'.safe_constantize
    if self.class.storage == fog
      ':class/:attachment/:id_partition/:style/:basename.:extension'
    else
      ':rails_root/public/system/:class/:attachment/:id_partition/:style/:basename.:extension'
    end
  end
end
