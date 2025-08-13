#!/bin/bash

set -e

export SPARK_NO_DAEMONIZE=true

#TODO MAKE THIS CRASH IF IT FAILS, BECAUSE RIGHT NOW IT DOESNT CRASH IF IT FAILS
/opt/scripts/check_env.sh

if [ "$SPARK_MODE" = "master" ]; then
    exec "$SPARK_HOME/sbin/start-master.sh"

elif [ "$SPARK_MODE" = "worker" ]; then
    [ -z "$SPARK_MASTER_URL" ] && { echo "Error: SPARK_MASTER_URL required for worker mode"; exit 1; }
    exec "$SPARK_HOME/sbin/start-worker.sh" "$SPARK_MASTER_URL"

else
    echo "Error: SPARK_MODE must be 'master' or 'worker'"
    exit 1
fi