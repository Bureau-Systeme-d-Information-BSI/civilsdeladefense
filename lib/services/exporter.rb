require "csv"

class Exporter
  attr_reader :data, :kind, :user

  def initialize(data, kind, user)
    @data = [data].flatten
    @kind = kind.to_sym
    @user = user
  end

  def generate
    CSV.generate do |csv|
      fill_csv(csv)
    end
  end

  private

  def fill_csv(csv)
    csv << []
    csv << [Time.zone.now.strftime("%d/%m/%Y %H:%M")]
    csv << [user.email]
    csv << []
    data.map do |line|
      case kind
      when :job_offer
        csv << format_job_offer(line)
      end
    end
  end

  def format_job_offer(job_offer)
    [
      job_offer.identifier,
      job_offer.title,
      job_offer.employer.name,
      job_offer.sector.name,
      job_offer.contract_type.name,
      job_offer.duration_contract,
      job_offer.job_applications_count,
      JobOffer.human_attribute_name("state/#{job_offer.state}"),
      JobApplication.human_attribute_name("state/#{job_offer.most_advanced_job_applications_state}"),
      job_offer.published_at&.strftime("%d/%m/%Y %H:%M"),
      job_offer.location,
      job_offer.category.name,
      job_offer.estimate_monthly_salary_net,
      job_offer.estimate_annual_salary_gross,
      job_offer.job_offer_actors.map { |a| a.administrator.email }.join(", ")
    ]
  end
end
