#!/usr/bin/env bash
set -x

if [ "$DO_NOT_POSTDEPLOY" = "1" ] ; then
  echo "Postdeploy hook disabled"
  exit 0
else
  bundle exec rails db:migrate
  if [ "$IS_REVIEW_APP" != "true" ]; then
    curl $SENTRY_DEPLOY_HOOK -X POST -H 'Content-Type: application/json' -d "{\"version\": \"${CONTAINER_VERSION}\"}"
  fi
fi
