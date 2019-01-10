module C100App
  class Status
    UNKNOWN_VERSION ||= 'unknown'.freeze

    def result
      {
        service_status: service_status,
        version: version,
        dependencies: {
          database_status: database_status,
          courtfinder_status: courtfinder_status
        }
      }
    end

    def success?
      service_status.eql?('ok')
    end

    private

    # When building the docker image, this and other bits of info are set.
    def version
      ENV['APP_GIT_COMMIT'] || UNKNOWN_VERSION
    end

    def database_status
      # This will only catch high-level failures.  PG::ConnectionBad gets
      # raised too early in the stack to rescue here.
      @database_status ||= (ActiveRecord::Base.connection ? 'ok' : 'failed')
    end

    def courtfinder_status
      @courtfinder_status ||= (CourtfinderAPI.new.is_ok? ? 'ok' : 'failed')
    end

    def service_status
      if [database_status, courtfinder_status].all? { |status| status.eql? 'ok' }
        'ok'
      else
        'failed'
      end
    end
  end
end
