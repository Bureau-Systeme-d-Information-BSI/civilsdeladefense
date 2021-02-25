# frozen_string_literal: true

json.array! @job_offers, partial: "job_offers/job_offer", as: :job_offer
