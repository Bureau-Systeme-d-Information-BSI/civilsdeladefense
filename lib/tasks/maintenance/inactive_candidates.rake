require "csv"

namespace :maintenance do
  desc "Output inactive candidate accounts as CSV (no activity since INACTIVE_SINCE, default 2024-07-01)"
  task inactive_candidates_csv: :environment do
    cutoff = inactivity_cutoff
    format_time = ->(time) { time&.strftime("%Y-%m-%d %H:%M:%S") }

    scoped_applications = JobApplication.unscoped.where.not(user_id: nil)
    application_counts = scoped_applications.group(:user_id).count
    last_application_dates = scoped_applications.group(:user_id).maximum(:created_at)

    csv = CSV.new($stdout)
    csv << [
      "id",
      "last name",
      "first name",
      "registration date",
      "update date",
      "last activity date",
      "number of applications",
      "last application date"
    ]

    listed = 0
    inactive_since(cutoff).find_each do |user|
      listed += 1
      csv << [
        user.id,
        user.last_name,
        user.first_name,
        format_time.call(user.created_at),
        format_time.call(user.updated_at),
        format_time.call(user.last_sign_in_at),
        application_counts[user.id] || 0,
        format_time.call(last_application_dates[user.id])
      ]
    end

    warn "#{listed} inactive candidate accounts since #{cutoff.to_date} (no activity since that date)."
  end

  desc "Delete the inactive candidate accounts listed by maintenance:inactive_candidates_csv (dry-run unless CONFIRM=yes)"
  task purge_inactive_candidates: :environment do
    cutoff = inactivity_cutoff
    scope = inactive_since(cutoff)
    total = scope.count

    unless ENV["CONFIRM"] == "yes"
      puts "[DRY-RUN] #{total} inactive candidate accounts since #{cutoff.to_date} would be deleted."
      puts "Re-run with CONFIRM=yes to actually delete them."
      next
    end

    puts "Deleting #{total} inactive candidate accounts since #{cutoff.to_date}..."
    deleted = 0
    failed = []
    scope.find_each do |user|
      user.destroy!
      deleted += 1
      puts "  #{deleted}/#{total} deleted" if (deleted % 100).zero?
    rescue => e
      failed << user.id
      warn "  failed to delete #{user.id}: #{e.message}"
    end

    puts "Done. #{deleted} candidate accounts deleted, #{failed.size} failed."
  end
end

private

# Cutoff before which an account is considered inactive.
# Overridable through the INACTIVE_SINCE environment variable.
def inactivity_cutoff
  Time.zone.parse(ENV["INACTIVE_SINCE"].presence || "2024-07-01")
end

# Candidate accounts without any activity since the given cutoff:
# registered before the cutoff, never signed in (or before the cutoff),
# no current session since the cutoff and no job application since the cutoff.
#
# Suspended accounts are excluded: the Suspendable concern forbids their
# deletion, so they could never be purged and must not appear in the list.
def inactive_since(cutoff = inactivity_cutoff)
  recently_active = JobApplication.unscoped
    .where.not(user_id: nil)
    .where(job_applications: {created_at: cutoff..})
    .select(:user_id)

  User.unscoped
    .where(suspended_at: nil)
    .where(users: {created_at: ...cutoff})
    .where("users.last_sign_in_at IS NULL OR users.last_sign_in_at < ?", cutoff)
    .where("users.current_sign_in_at IS NULL OR users.current_sign_in_at < ?", cutoff)
    .where.not(id: recently_active)
end
