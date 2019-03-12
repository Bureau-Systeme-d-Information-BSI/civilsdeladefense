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
