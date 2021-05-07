class Exporter::Base
  attr_reader :data, :user

  def initialize(data, user)
    @data = data
    @user = user
  end

  def generate
    p = Axlsx::Package.new
    p.workbook.add_worksheet do |sheet|
      basic_data(sheet)
      fill_data(sheet)
    end
    p.to_stream
  end

  def fill_data(sheet)
  end

  private

  def basic_data(sheet)
    sheet.add_row([])
    sheet.add_row([Time.zone.now.strftime("%d/%m/%Y %H:%M")])
    sheet.add_row([user.email])
    sheet.add_row([data.count]) if data.respond_to?(:count)
    sheet.add_row([])
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
end
