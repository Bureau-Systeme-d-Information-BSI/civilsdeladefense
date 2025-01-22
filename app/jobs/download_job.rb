class DownloadJob < ApplicationJob
  queue_as :default

  def perform(resource_type:, attribute_name:, id:, file_name:)
    return if file_name.blank?

    resource = resource_type.constantize.find(id)
    resource.send(:"#{attribute_name}=", download(resource_type, attribute_name, id, file_name))
    resource.save(validate: false)

    File.delete(file_name) if File.exist?(file_name)
  end

  private

  def download(resource_type, attribute_name, id, file_name)
    url = "https://ict-tct.contractuels.civils.defense.gouv.fr/downloads/#{id}?resource_type=#{resource_type}&attribute_name=#{attribute_name}"
    content = URI.open(url, "X-Download-Secret-Key" => ENV["DOWNLOAD_SECRET_KEY"]).read.force_encoding("UTF-8") # rubocop:disable Security/Open
    File.write(file_name, content)
    File.open(file_name)
  rescue OpenURI::HTTPError
    nil
  end
end
