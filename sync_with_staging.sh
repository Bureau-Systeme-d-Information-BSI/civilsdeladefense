#!/usr/bin/env bash
set -xe

APP_NAME=erecrutement-cvd-staging
ADDON_ID=`scalingo --app $APP_NAME addons | grep postgre | awk '{ print $4; }'`
BACKUP_ID=`scalingo --app $APP_NAME backups --addon $ADDON_ID | awk 'NR==4' | awk '{ print $2; }'`
ARCHIVE_PATH=`scalingo --app $APP_NAME --addon $ADDON_ID backups-download --backup $BACKUP_ID --output tmp | awk 'NR==2' | awk '{ print $2; }'`
tar -xzf $ARCHIVE_PATH -C tmp --strip-components 1
DUMP_PATH=${ARCHIVE_PATH/.tar.gz/.pgsql}
rails db:drop db:create
pg_restore --clean --if-exists --no-owner --no-privileges --no-comments --dbname postgresql://jean_scalingo@localhost:5432/civilsdeladefense_development $DUMP_PATH
rails db:migrate
