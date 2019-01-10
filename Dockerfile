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

ARG APP_BUILD_DATE
ENV APP_BUILD_DATE ${APP_BUILD_DATE}

ARG APP_BUILD_TAG
ENV APP_BUILD_TAG ${APP_BUILD_TAG}

ARG APP_GIT_COMMIT
ENV APP_GIT_COMMIT ${APP_GIT_COMMIT}

ARG APP_VERSION
ENV APP_VERSION ${APP_VERSION}

EXPOSE $PUMA_PORT
ENTRYPOINT ["./run.sh"]
