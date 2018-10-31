FROM ministryofjustice/ruby:2.5.1-webapp-onbuild

# So the PDF has nice fonts (free alternative to MS fonts)
RUN apt-get update && apt-get install fonts-liberation

# The following are ENV variables that need to be present by the time
# the assets pipeline run, but doesn't matter their value.
#
ENV EXTERNAL_URL            replace_this_at_build_time
ENV SECRET_KEY_BASE         replace_this_at_build_time
ENV GOVUK_NOTIFY_API_KEY    replace_this_at_build_time

RUN bundle exec rake assets:precompile

ENV RAILS_ENV production
ENV PUMA_PORT 3000

EXPOSE $PUMA_PORT

ENTRYPOINT ["./run.sh"]
