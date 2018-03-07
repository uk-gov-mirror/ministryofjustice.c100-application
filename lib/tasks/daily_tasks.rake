task :daily_tasks do
  log 'Starting daily tasks'

  Rake::Task['draft_reminders:first_email'].invoke
  Rake::Task['draft_reminders:last_email'].invoke

  log 'Finished daily tasks'
end

namespace :draft_reminders do
  task :first_email => :environment do |task_name|
    rule_set = C100App::ReminderRuleSet.first_reminder

    log "#{task_name} - Count: #{rule_set.count}"
    C100App::DraftReminders.new(rule_set: rule_set).run
  end

  task :last_email => :environment do |task_name|
    rule_set = C100App::ReminderRuleSet.last_reminder

    log "#{task_name}  - Count: #{rule_set.count}"
    C100App::DraftReminders.new(rule_set: rule_set).run
  end
end

private

def log(message)
  puts "[#{Time.now}] #{message}"
end
