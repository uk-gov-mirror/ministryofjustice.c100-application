require 'optparse'

namespace :court_refresh do
  #
  # Use with (provide a slug, email or both):
  #   bundle exec rake court_refresh:slug -- --slug test-foobar --email email@test.com
  #
  # Note the criteria will only select applications saved (`with_owner`)
  # and not yet completed. We should never change a completed application.
  #
  task slug: :environment do
    ARGV.shift(2)

    slug, email = nil
    count = 0

    OptionParser.new do |opts|
      opts.on("--slug ARG",  String) { |str| slug = str }
      opts.on("--email ARG", String) { |str| email = str }
    end.parse!

    unless slug || email
      raise ArgumentError, '`--slug ARG` or `--email ARG` needs to be provided'
    end

    criteria = [].tap do |c|
      c << "screener_answers.local_court->>'slug' = ?"  if slug
      c << "screener_answers.local_court->>'email' = ?" if email
    end.join(' AND ')

    C100Application.with_owner.not_completed.joins(:screener_answers).where(
      criteria, *[slug, email].compact
    ).find_each(batch_size: 25) do |record|
      screener = record.screener_answers

      puts "Enqueuing court refresh for ID #{screener.id}..."
      ScreenerCourtRefreshJob.perform_later(screener)

      count += 1
    end

    puts "Finished. Total: #{count}"
    exit(0)
  end
end
