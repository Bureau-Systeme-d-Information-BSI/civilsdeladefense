class DailySummary
  delegate :url_helpers, to: 'Rails.application.routes'

  def initialize(day: Date.yesterday)
    @day = day
    @day_begin = @day.beginning_of_day
    @day_end = @day.end_of_day
    @concerned_administrators = []
  end

  def prepare_and_send
    prepare
    send_mail
  end

  def all_bants
    @all_bants ||= Administrator.where(role: :bant).all
  end

  def prepare
    prepare_new_job_offers
    prepare_new_job_applications
    prepare_job_applications
  end

  def send_mail
    administrators = Administrator.find @concerned_administrators.map(&:uuid)

    @concerned_administrators.each { |concerned_administrator|
      administrator = administrators.detect{|x| x.id == concerned_administrator.uuid}
      data = concerned_administrator.summary_infos
      NotificationsMailer.daily_summary(administrator, data).deliver
    }
  end

  def prepare_new_job_offers
    @job_offers = JobOffer.where(created_at: @day_begin..@day_end).order(created_at: :asc).to_a
    @job_offers.each{|job_offer|
      add_summary_infos_for_job_offer(job_offer)
    }
  end

  def add_summary_infos_for_job_offer(job_offer)
    administrators = job_offer.employer_actors + job_offer.grand_employer_actors + job_offer.supervisor_employer_actors + job_offer.brh_actors + all_bants
    administrators = administrators.uniq
    administrators.each{|administrator|
      concerned_administrator = @concerned_administrators.detect{|x| x.uuid == administrator.id}
      prexisting = true
      if !concerned_administrator
        prexisting = false
        concerned_administrator = DailySummaryConcernedAdministrator.new(uuid: administrator.id)
      end
      concerned_administrator.add_summary_info({
        title: job_offer.title,
        link: url_helpers.edit_admin_job_offer_url(job_offer),
        kind: 'NewJobOffer'
      })
      @concerned_administrators << concerned_administrator unless prexisting
    }
  end

  def prepare_new_job_applications
    @job_applications = JobApplication.where(created_at: @day_begin..@day_end).includes(:job_offer).order(created_at: :asc).to_a
    @job_applications.each{|job_application|
      add_summary_infos_for_job_application(job_application)
    }
  end

  def add_summary_infos_for_job_application(job_application, new_state = nil)
    job_offer = job_application.job_offer
    administrators = if new_state.nil?
      job_offer.employer_actors
    else
      job_offer.grand_employer_actors + job_offer.supervisor_employer_actors + job_offer.brh_actors + all_bants
    end
    administrators = administrators.uniq
    administrators.each{|administrator|
      concerned_administrator = @concerned_administrators.detect{|x| x.uuid == administrator.id}
      prexisting = true
      if !concerned_administrator
        prexisting = false
        concerned_administrator = DailySummaryConcernedAdministrator.new(uuid: administrator.id)
      end
      title, kind = if new_state.present?
        ["#{ job_application.full_name } ##{ job_offer.identifier }", "#{new_state.capitalize}JobApplication"]
      else
        ["#{ job_application.full_name } ##{ job_offer.identifier }", "NewJobApplication"]
      end
      concerned_administrator.add_summary_info({
        title: title,
        link: url_helpers.admin_job_offer_url(job_offer),
        kind: kind
      })
      @concerned_administrators << concerned_administrator unless prexisting
    }
  end

  def prepare_job_applications
    %w(accepted contract_received affected).each{ |state|
      audits = find_job_applications_by_state(state)
      audits.all.each {|element|
        job_application = element.auditable
        add_summary_infos_for_job_application(job_application, state)
      }
    }
  end

  private

    def find_job_applications_by_state(state)
      r = Audited::Audit.where(auditable_type: "JobApplication")
      r = r.where(created_at: @day_begin..@day_end)
      r = r.where("audited_changes->'state'->1 = ?", state.to_json)
      r = r.order(created_at: :desc)
      r = r.includes(:auditable)
    end
end
