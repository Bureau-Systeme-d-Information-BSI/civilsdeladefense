namespace :maintenance do
  task fixup_duplicate_files: :environment do
    rel = JobApplicationFile.select(:job_application_file_type_id, :job_application_id)
                            .group(:job_application_file_type_id, :job_application_id)
                            .having('count(*) > 1')
    rel.each do |zombie|
      hsh = {
        job_application_file_type_id: zombie.job_application_file_type_id,
        job_application_id: zombie.job_application_id
      }
      files = JobApplicationFile.where(hsh).to_a
      by_is_validated = files.group_by(&:is_validated)
      by_is_validated_0 = by_is_validated[0] || []
      by_is_validated_1 = by_is_validated[1] || []
      by_is_validated_2 = by_is_validated[2] || []
      if by_is_validated_0.size == files.size
        # no file has been validated yet
        # we can destroy the oldest ones
        sorted_by_created_at = files.sort_by(&:created_at)
        the_last_one_to_keep = sorted_by_created_at.pop
        sorted_by_created_at.each do |file|
          destroy_file(file)
        end
      elsif by_is_validated_1.size == 1 && by_is_validated_2.size == 0
        # only one file flagged valid, no other touched
        # we can destroy the other
        (by_is_validated_0 + by_is_validated_2).each do |file|
          destroy_file(file)
        end
      elsif by_is_validated_2.size == 1 && by_is_validated_1.size == 0
        # only one file flagged invalid, no other touched
        # we can destroy the other
        (by_is_validated_0 + by_is_validated_1).each do |file|
          destroy_file(file)
        end
      else
        # we cannot do anything except destroying the oldest files
        sorted_by_created_at = files.sort_by(&:created_at)
        the_last_one_to_keep = sorted_by_created_at.pop
        sorted_by_created_at.each do |file|
          destroy_file(file)
        end
      end
    end
  end

  def destroy_file(file)
    begin
      file.destroy
    rescue Fog::OpenStack::Storage::NotFound => e
      Rails.logger.debug "Deletion failed for file #{file.inspect}"
    end
  end
end


