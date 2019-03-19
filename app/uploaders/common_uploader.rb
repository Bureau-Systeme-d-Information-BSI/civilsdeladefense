class CommonUploader < CarrierWave::Uploader::Base
  include CarrierWave::Compatibility::Paperclip

  def paperclip_path
    self.class.mappings[:id_partition] = lambda{|u, f| u.model.id.scan(/.{3}/).first(3).join("/".freeze)}
    if self.class.storage == CarrierWave::Storage::Fog
      ":class/:attachment/:id_partition/:style/:basename.:extension"
    else
      ":rails_root/public/system/:class/:attachment/:id_partition/:style/:basename.:extension"
    end
  end
end
