# frozen_string_literal: true

# Job offer state actions metaprogrammed from the array of state names
module JobOfferStateActions
  extend ActiveSupport::Concern

  def create_and_publish
    @job_offer = JobOffer.new(job_offer_params)
    @job_offer.owner = current_administrator
    @job_offer.employer = current_administrator.employer unless current_administrator.bant?
    @job_offer.job_offer_actors.each do |job_offer_actor|
      if job_offer_actor.administrator
        job_offer_actor.administrator.inviter ||= current_administrator
      end
    end
    @job_offer.publish
    respond_to do |format|
      if @job_offer.save
        format.html { redirect_to %i[admin job_offers], notice: t('.success') }
        format.json { render :show, status: :created, location: @job_offer }
      else
        format.html { render :new }
        format.json { render json: @job_offer.errors, status: :unprocessable_entity }
      end
    end
  end

  JobOffer.aasm.events.map(&:name).each do |event_name|
    define_method(event_name) do
      state_action(event_name)
    end

    define_method("update_and_#{event_name}".to_sym) do
      update_and_state_action(event_name)
    end
  end

  protected

  def state_action(event_name)
    @job_offer.send("#{event_name}!")
    respond_to do |format|
      format.html { redirect_back(fallback_location: job_offers_url, notice: t('.success')) }
      format.js do
        @notification = t('.success')
        render :state_change
      end
      format.json { render :show, status: :ok, location: @job_offer }
    end
  end

  def update_and_state_action(event_name)
    @job_offer.assign_attributes(job_offer_params)
    @job_offer.cleanup_actor_administrator_inviter(current_administrator)

    respond_to do |format|
      if @job_offer.save && @job_offer.send("#{event_name}!")
        format.html { redirect_to %i[admin job_offers], notice: t('.success') }
        format.json { render :show, status: :ok, location: @job_offer }
      else
        format.html { render :edit }
        format.json { render json: @job_offer.errors, status: :unprocessable_entity }
      end
    end
  end
end
