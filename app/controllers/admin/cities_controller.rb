class Admin::CitiesController < Admin::BaseController
  skip_load_and_authorize_resource

  # TODO: SEB on change :
  # const properties = item.properties
  # const context = item.properties.context
  # const splittedContext = item.properties.context.split(", ") # 59, Nord, Hauts-de-France
  # this.locationTarget.value = `${item.properties.label}, ${context}`
  # this.cityTarget.value = properties.city # Ville (Lille)
  # this.postcodeTarget.value = properties.postcode # Code postal (59000)
  # this.countyCodeTarget.value = splittedContext[0] # Code département (59)
  # this.countyTarget.value = splittedContext[1] # Département (Nord)
  # this.regionTarget.value = splittedContext[2] # Region (Hauts-de-France)
  # this.countryCodeTarget.value = "fr" # Pays (fr)
  def index = @cities = query? ? convert_raw_data_to_cities(search_for_cities) : []

  private

  City = Data.define(:id, :label, :context) do
    def to_combobox_display = "#{label} (#{context})"
  end

  def search_for_cities
    uri = URI("https://api-adresse.data.gouv.fr/search/")
    uri.query = URI.encode_www_form(q: query, type: "municipality")
    JSON.parse(Net::HTTP.get(uri))["features"].pluck("properties")
  end

  def convert_raw_data_to_cities(json) = json.map { |city| City.new(city["id"], city["label"], city["context"]) }

  def query? = query.present? && query.length > 2

  def query = params[:q]
end
