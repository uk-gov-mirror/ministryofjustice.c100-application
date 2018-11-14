class RefactorApplicationsAudit < ActiveRecord::Migration[5.1]
  #
  # This migration will not rollback as it is coupled to new code.
  # All current stored data is preserved and nothing is lost.
  # We just move around some fields to the new `metadata` column.
  #
  def up
    return if column_exists?(:completed_applications_audit, :metadata)

    add_column :completed_applications_audit, :metadata, :json, default: {}

    migrate_current_data!

    remove_column :completed_applications_audit, :saved
    remove_column :completed_applications_audit, :urgent_hearing
  end

  private

  def migrate_current_data!
    CompletedApplicationsAudit.find_each(batch_size: 100) do |record|
      record.update_column(:metadata, {
        saved_for_later: record.saved,
        urgent_hearing: record.urgent_hearing,
      })
    end
  end
end
