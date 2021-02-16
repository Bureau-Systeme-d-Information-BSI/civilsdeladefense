#!/usr/bin/env bash
set -x

if [ "$DO_NOT_POSTDEPLOY" = "1" ] ; then
  echo "Postdeploy hook disabled"
  exit 0
else
  bundle exec rails db:migrate
  if [ "$IS_REVIEW_APP" != "true" ]; then
    curl https://api.rollbar.com/api/1/deploy/ -F access_token=$ROLLBAR_ACCESS_TOKEN -F environment=$ROLLBAR_ENV -F revision=$CONTAINER_VERSION -F local_username=scalingo
  fi
fi
