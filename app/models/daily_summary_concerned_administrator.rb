# frozen_string_literal: true

# Virtual class to gather administrator concerned by a daily summary.
# They will be the recipient of the daily summary email.
class DailySummaryConcernedAdministrator
  attr_accessor :uuid, :summary_infos
  def initialize(uuid: nil)
    @uuid = uuid
    @summary_infos = []
  end

  def add_summary_info(info)
    @summary_infos << info
  end
end
