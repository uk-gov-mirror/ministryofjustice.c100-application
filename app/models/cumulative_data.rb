class CumulativeData < ApplicationRecord
  # Data points processed daily through `/lib/tasks/daily_tasks.rake`
  #
  # To create new data points, add the field to the table and to this
  # collection, and then implement a class method of the same name.
  #
  DATA_POINTS ||= [
    :applications_created,
    :applications_eligible,
    :applications_completed,
    :applications_saved,
    :applications_online_submission,
    :applications_postal_submission,
    :miam_kickouts,
    :miam_expired,
  ].freeze

  class << self
    attr_accessor :reading_date

    def process!(reading_date = Date.yesterday)
      @reading_date = reading_date

      data_points = {
        reading_date: @reading_date
      }

      DATA_POINTS.each_with_object(data_points) do |column, hash|
        hash[column] = public_send(column)
      end

      create(data_points)
    end

    def finder
      C100Application.where(
        created_at: (reading_date.beginning_of_day..reading_date.end_of_day)
      )
    end

    #
    # Implement new data points below, as class methods
    #
    def applications_created
      finder.count
    end

    # Any application that has completed the screener, no matter the status
    def applications_eligible
      finder.where(
        'navigation_stack && ?', '{/steps/screener/done, /entrypoint/v1}'
      ).count
    end

    def applications_completed
      finder.completed.count
    end

    def applications_saved
      finder.with_owner.count
    end

    def applications_online_submission
      finder.where(
        submission_type: SubmissionType::ONLINE.to_s
      ).count
    end

    def applications_postal_submission
      finder.where(
        submission_type: SubmissionType::PRINT_AND_POST.to_s
      ).count
    end

    def miam_kickouts
      finder.where(
        'navigation_stack && ?', '{/steps/miam_exemptions/exit_page}'
      ).count
    end

    def miam_expired
      finder.where(
        'navigation_stack && ?', '{/steps/miam/certification_expired_info}'
      ).count
    end
  end
end
