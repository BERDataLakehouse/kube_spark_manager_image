#!/bin/bash

if [ "$SPARK_MODE" = "master" ]; then
    REQUIRED_VARS=(
        "SPARK_MODE"
        "SPARK_MASTER_HOST"
        "SPARK_MASTER_PORT"
        "SPARK_MASTER_WEBUI_PORT"
    )
elif [ "$SPARK_MODE" = "worker" ]; then
    REQUIRED_VARS=(
        "SPARK_MASTER_URL"
        "SPARK_WORKER_CORES"
        "SPARK_WORKER_MEMORY"
        "SPARK_WORKER_PORT"
        "SPARK_WORKER_WEBUI_PORT"
        "BERDL_REDIS_HOST"
        "BERDL_REDIS_PORT"
        "BERDL_DELTALAKE_WAREHOUSE_DIRECTORY_PATH"
        "BERDL_HIVE_METASTORE_URI"
    )
else
    echo "Error: SPARK_MODE must be 'master' or 'worker'"
    exit 1
fi

MISSING_VARS=""

for env in "${REQUIRED_VARS[@]}"; do
    if [ -z "${!env}" ]; then
        MISSING_VARS="$MISSING_VARS $env"
    fi
done

if [ -n "$MISSING_VARS" ]; then
    echo "Error: Missing required environment variables:$MISSING_VARS"
    exit 1
fi

echo "✅ All required environment variables are set for $SPARK_MODE mode"