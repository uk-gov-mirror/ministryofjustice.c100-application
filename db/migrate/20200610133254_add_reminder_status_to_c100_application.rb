class AddReminderStatusToC100Application < ActiveRecord::Migration[5.2]
  def up
    add_column :c100_applications, :reminder_status, :string
    migrate_existing_reminders!
  end

  def down
    remove_column :c100_applications, :reminder_status
  end

  private

  def migrate_existing_reminders!
    C100Application.where(status: 5).find_each(batch_size: 25) do |record|
      record.update_column(
        :reminder_status, 'first_reminder_sent'
      )
    end

    C100Application.where(status: 6).find_each(batch_size: 25) do |record|
      record.update_column(
        :reminder_status, 'last_reminder_sent'
      )
    end
  end
end
