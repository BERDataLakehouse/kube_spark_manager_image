#!/bin/bash


set -e

echo "Starting container in mode: $SPARK_MODE"
SPARK_NO_DAEMONIZE=true

./opt/scripts/check_env.sh


if [ "$SPARK_MODE" = "master" ]; then
  echo "Starting Spark Master..."
  bash "$SPARK_HOME/sbin/start-master.sh"

elif [ "$SPARK_MODE" = "worker" ]; then
  if [ -z "$SPARK_MASTER_URL" ]; then
    echo "Error: SPARK_MASTER_URL environment variable must be set for worker mode."
    exit 1
  fi
  echo "Starting Spark Worker and connecting to master at $SPARK_MASTER_URL..."
  bash "$SPARK_HOME/sbin/start-worker.sh" "$SPARK_MASTER_URL"

else
  echo "Error: Unknown role '$SPARK_MODE'. Please specify 'master' or 'worker'."
  exit 1
fi