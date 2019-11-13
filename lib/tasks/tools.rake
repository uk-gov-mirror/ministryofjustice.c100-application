namespace :tools do
  task fix_audit: :environment do
    rows = File.readlines(
      File.join(Rails.root, 'audit_courts.csv')
    )

    puts "fixing #{rows.size} rows..."

    rows.each do |data|
      completed_at, court, reference_code = data.chomp.split(',')

      ActiveRecord::Base.connection.execute(
        "UPDATE completed_applications_audit SET reference_code = '#{reference_code}', court = '#{court}' WHERE completed_at = '#{completed_at}'"
      )
    end

    puts 'done'
  end
end
