module C100App
  class Status
    def self.check
      new.check
    end

    def check
      {
        service_status: service_status,
        version: version,
        dependencies: {
          database_status: database_status,
          courtfinder_status: courtfinder_status
        }
      }
    end

    private

    def version
      # This has been manually checked in a demo app in a docker container running
      # ruby:latest with Docker 1.12. Ymmv, however; in particular it may not
      # work on alpine-based containers. It is mocked at the method level in the
      # specs, so it is possible to simply comment the call out if there are
      # issues with it.
      `git rev-parse HEAD`.chomp
    end

    def database_status
      # This will only catch high-level failures.  PG::ConnectionBad gets
      # raised too early in the stack to rescue here.
      @database_status ||= if ActiveRecord::Base.connection
                             'ok'
                           else
                             'failed'
                           end
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
