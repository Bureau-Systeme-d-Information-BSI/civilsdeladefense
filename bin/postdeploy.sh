#!/usr/bin/env bash
set -x

if [ "$DO_NOT_POSTDEPLOY" = "1" ] ; then
  echo "Postdeploy hook disabled"
  exit 0
else
  bundle exec rails db:migrate
fi
