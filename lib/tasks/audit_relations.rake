# This task can be removed once run.
# It is only needed to retroactively populate some audit information
#
task :audit_relations => :environment do
  C100Application.completed.where.not(permission_sought: nil).each do |c100|
    audit = CompletedApplicationsAudit.find_by(reference_code: c100.reference_code)
    next unless audit

    puts "Updating relationships for application #{c100.id}"

    audit.metadata[:relationships] = relationships_to_children(c100)
    audit.save
  end
end

private

def relationships_to_children(c100)
  Relationship.distinct.where(
    person_id: c100.applicant_ids, minor_id: c100.child_ids
  ).pluck(:relation)
end
