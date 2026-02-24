class Admin::CitiesController < Admin::BaseController
  skip_load_and_authorize_resource

  def index = @cities = query? ? convert_raw_data_to_cities(search_for_cities) : []

  def show = render json: search_for_cities.find { |c| c["id"] == params[:id] }

  private

  City = Data.define(:id, :label, :name, :context, :postcode) do
    def to_combobox_display = "#{label}, #{context}"

    def county_code = context.split(", ")[0]

    def county = context.split(", ")[1]

    def region = context.split(", ")[2]

    def country_code = "fr"
  end

  def search_for_cities
    uri = URI("https://api-adresse.data.gouv.fr/search/")
    uri.query = URI.encode_www_form(q: query, type: "municipality")
    JSON.parse(Net::HTTP.get(uri))["features"].pluck("properties")
  end

  def convert_raw_data_to_cities(json)
    json.map { |city| City.new(city["id"], city["label"], city["city"], city["context"], city["postcode"]) }
  end

  def query? = query.present? && query.length > 2

  def query = params[:q]
end
