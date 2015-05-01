#!/bin/bash
# Starts up the Phabricator stack within the container.

# Stop on error
#set -e

DATA_DIR=/data
LOG_DIR=/var/log

for f in `ls /scripts/functions/*.sh`; do
  . $f
done

if [[ -e /first_run ]]; then
  . /scripts/first_run.sh
else
  . /scripts/normal_run.sh
fi

pre_start_action
post_start_action

exec supervisord
