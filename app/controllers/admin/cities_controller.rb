class Admin::CitiesController < Admin::BaseController
  skip_load_and_authorize_resource

  # TODO: SEB specs
  def index
    result = Net::HTTP.get(URI.parse("https://api-adresse.data.gouv.fr/search/?q=#{params[:q]}&type=municipality"))
    # TODO: SEB format the result
    @cities = JSON.parse(result)["features"].map { |feature| feature["properties"]["label"] }
    # TODO: SEB store the right data in the database
  end
end
