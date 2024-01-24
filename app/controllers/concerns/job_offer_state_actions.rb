# frozen_string_literal: true

# Job offer state actions metaprogrammed from the array of state names
module JobOfferStateActions
  extend ActiveSupport::Concern

  def create_and_publish
    @job_offer = JobOffer.new(job_offer_params)
    @job_offer.owner = current_administrator
    @job_offer.organization = current_organization
    @job_offer.employer = current_administrator.employer unless current_administrator.bant?
    @job_offer.job_offer_actors.each do |job_offer_actor|
      if job_offer_actor.administrator
        job_offer_actor.administrator.inviter ||= current_administrator
      end
    end
    @job_offer.publish
    if @job_offer.save
      redirect_to %i[admin job_offers], notice: t(".success")
    else
      render :new
    end
  end

  JobOffer.aasm.events.map(&:name).each do |event_name|
    define_method(event_name) do
      state_action(event_name)
    end

    define_method(:"update_and_#{event_name}") do
      update_and_state_action(event_name)
    end
  end

  protected

  def state_action(event_name)
    if @job_offer.send(:"#{event_name}!")
      respond_to do |format|
        format.html { redirect_back(fallback_location: %i[admin job_offers], notice: t(".success")) }
        format.js do
          @notification = t(".success")
          render :state_change
        end
      end
    else
      respond_to do |format|
        format.html do
          redirect_back(fallback_location: %i[admin job_offers], notice: @job_offer.errors.full_messages.to_sentence)
        end
        format.js do
          @notification = @job_offer.errors.full_messages.to_sentence
          render :state_unchanged
        end
      end
    end
  end

  def update_and_state_action(event_name)
    @job_offer.assign_attributes(job_offer_params)
    @job_offer.cleanup_actor_administrator_dep(current_administrator, current_organization)

    if @job_offer.send(:"#{event_name}!") && @job_offer.save
      redirect_to %i[admin job_offers], notice: t(".success")
    else
      render :edit
    end
  end
end
