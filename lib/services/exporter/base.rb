class Exporter::Base
  attr_reader :data, :user, :name, :sheet

  def initialize(data, user, name: nil)
    @data = data
    @user = user
    @name = name
  end

  def generate
    p = Axlsx::Package.new
    p.workbook.add_worksheet do |sheet|
      @sheet = sheet
      basic_data
      fill_data
    end
    p.to_stream
  end

  def fill_data
  end

  private

  def add_row(*row)
    sheet.add_row(row.flatten)
  end

  def basic_data
    add_row
    add_row(Time.zone.now.strftime("%d/%m/%Y %H:%M"))
    add_row(user.email)
    add_row(name) if name
    add_row(data.count) if data.is_a?(Array)
    add_row
  end

  def format_actors(job_offer_actors)
    job_offer_actors.map { |actor|
      administrator = actor.administrator
      [
        JobOfferActor.human_attribute_name("role.#{actor.role}"),
        "#{administrator.first_name} #{administrator.last_name}",
        administrator.email
      ].join(" ")
    }.join(", ")
  end

  def remove_html(value)
    ActionView::Base.full_sanitizer.sanitize(value)
  end

  def localize(date)
    return if date.blank?

    I18n.l(date)
  end

  def number_to_percentage(number, options = {})
    ActiveSupport::NumberHelper::NumberToPercentageConverter.convert(number, options)
  end
end
