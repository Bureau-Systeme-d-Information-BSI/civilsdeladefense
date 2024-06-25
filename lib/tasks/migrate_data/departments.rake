namespace :migrate_data do
  task none_department: :environment do
    Rails.logger.info("Find or create None department")
    none_department = Department.none

    scope = User.where.missing(:department_users)
    Rails.logger.info("Migration start for #{scope.count} users")
    scope.find_each do |user|
      Rails.logger.info("Adding None department to #{user.id}")
      user.department_users.create!(department: none_department)
    end
    Rails.logger.info("All done!")
  end
end
