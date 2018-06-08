namespace :misc do
  # This task can be removed once it has been run, as it serves
  # no other purpose than pre-populate a fresh DB table.
  #
  task prepopulate_audit: :environment do
    C100Application.completed.order(updated_at: :asc).each do |c100_application|
      CompletedApplicationsAudit.log!(c100_application)
    end
  end
end
