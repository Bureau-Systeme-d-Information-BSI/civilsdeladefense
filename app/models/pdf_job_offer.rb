class PdfJobOffer < SimpleDelegator
  include Prawn::View
  include JobOffersHelper

  def initialize(job_offer)
    super(job_offer)
    build
  end

  def filename = "#{title.parameterize}.pdf"

  private

  def build
    add_header
    add_logo if logo?
    add_vertical_space
    add_title
    add_location
    add_vertical_space
    add_attributes
    add_vertical_space
    add_contents
  end

  def add_header
    bounding_box([0, cursor], width: 300) do
      text organization.service_name, size: 16, style: :bold
      text organization.service_description, size: 12
    end
  end

  def add_logo = image URI.open(logo_uri), width: 100, position: :right, vposition: :top  # rubocop:disable Security/Open

  def add_title = text title, size: 20, style: :bold, align: :center

  def add_location = text job_offer_value_for_attribute(self, :location), size: 12, align: :center

  def add_attributes = table attributes_tables, cell_style: attributes_style, width: bounds.width

  def attributes_tables
    [
      [attribute_table(:contract_type), attribute_table(:contract_start_on), attribute_table(:study_level)],
      [attribute_table(:category), attribute_table(:experience_level), attribute_table(:salary)],
      [attribute_table(:benefits), attribute_table(:drawbacks), attribute_table(:is_remote_possible)]
    ]
  end

  def attributes_style = {padding: 0, border_width: 0, inline_format: true}

  def attribute_table(attribute)
    make_table(attribute_data(attribute), cell_style: attribute_style, width: bounds.width / 3) do
      row(0).font_style = :bold
      row(0).size = 10
      row(0).background_color = "F0F0F0"
      row(1).height = 50
      row(1).size = 10
    end
  end

  def attribute_data(attribute) = [
    [JobOffer.human_attribute_name(attribute)],
    [convert_html_to_plain_text(job_offer_value_for_attribute(self, attribute))]
  ]

  def attribute_style = {padding: 5, border_width: 0.5, border_color: "DCDCDC"}

  def add_contents = content_attributes.each { |attribute| add_content(attribute) }

  def content_attributes = %i[organization_description description required_profile recruitment_process]

  def add_content(attribute)
    text I18n.t("job_offers.job_offer_content.#{attribute}"), size: 16, style: :bold
    add_vertical_space(space: 10)
    text convert_html_to_plain_text(send(attribute))
    add_vertical_space
  end

  def add_vertical_space(space: 20) = move_down space

  def convert_html_to_plain_text(html) = ActionText::Content.new(html).to_plain_text

  def logo? = logo_uri.present?

  def logo_uri = @logo_uri ||= operator_logo.present? ? URI.join(ENV.fetch("DEFAULT_HOST"), operator_logo.url) : nil

  def document = @document ||= Prawn::Document.new(page_size: "A4", margin: 30)

  delegate :operator_logo, to: :organization
end
