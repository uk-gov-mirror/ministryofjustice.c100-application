FROM ministryofjustice/ruby:2.6.2-webapp-onbuild

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

# Download RDS certificates bundle -- needed for SSL verification
# We set the path to the bundle in the ENV, and use it in `/config/database.yml`
#
ENV RDS_COMBINED_CA_BUNDLE /usr/src/app/config/rds-combined-ca-bundle.pem
ADD https://s3.amazonaws.com/rds-downloads/rds-combined-ca-bundle.pem $RDS_COMBINED_CA_BUNDLE
RUN chmod +r $RDS_COMBINED_CA_BUNDLE

# Run the application as user `moj` (created in the base image)
# uid=1000(moj) gid=1000(moj) groups=1000(moj)
# Some directories/files need to be chowned otherwise we get Errno::EACCES
#
RUN mkdir -p ./usr/src/app/log ./usr/src/app/tmp && \
    chown -R $APPUSER:$APPUSER /usr/src/app/log /usr/src/app/tmp

ENV APPUID 1000
USER $APPUID

EXPOSE $PUMA_PORT
ENTRYPOINT ["./run.sh"]
