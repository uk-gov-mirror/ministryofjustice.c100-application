#!/bin/sh
cd /usr/src/app 2> /dev/null

ACTION=$1
RETRY_LIMIT=3
RETRY_FREQUENCY=5

start_function(){
  bundle exec sidekiq
}

stop_function(){
  # SIGTERM triggers a quick exit; gracefully terminate instead.
  # Find PID
  SIDEKIQ_PID=$(ps aux | grep sidekiq | grep busy | awk '{ print $2 }')

  if [[ -z "$SIDEKIQ_PID" ]]; then
    echo "No Sidekiq PIDs found."
  else
    echo "Sending TSTP signal..."
    kill -TSTP ${SIDEKIQ_PID}

    # Wait until it finishes all the jobs and then send a TERM signal to it
    wait_function

    echo "Sending TERM signal..."
    kill -TERM ${SIDEKIQ_PID}
  fi
}

probe_function(){
  sidekiqmon processes | grep 'Processes (0)' > /dev/null && exit 1 || exit 0
}

wait_function(){
  sleep 2

  i=0
  while [[ ${i} -lt ${RETRY_LIMIT} ]]; do
    i=$((i+1))

    IS_SIDEKIQ_DONE=$(sidekiqmon processes | grep -E "(1 busy)" > /dev/null)$?

    if [[ ${IS_SIDEKIQ_DONE} -eq 0 ]]; then
      echo "Sidekiq finished all jobs."
      break
    else
      echo "Sidekiq is still busy. Retry $i/$RETRY_LIMIT Waiting $RETRY_FREQUENCY seconds..."
      sleep ${RETRY_FREQUENCY}
    fi
  done
}


case "$ACTION" in
  start)
    start_function
    ;;
  stop)
    stop_function
    ;;
  restart)
    stop_function && start_function
    ;;
  probe)
    probe_function
    ;;
  *)
  echo "Usage: $0 [start|stop|restart|probe]"
esac
