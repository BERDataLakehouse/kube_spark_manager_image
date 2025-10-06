#!/bin/bash

set -e

export SPARK_NO_DAEMONIZE=true

#TODO MAKE THIS CRASH IF IT FAILS, BECAUSE RIGHT NOW IT DOESNT CRASH IF IT FAILS
/opt/scripts/check_env.sh

if [ "$SPARK_MODE" = "master" ]; then
    # Start Spark Connect server if enabled
    if [ "$SPARK_CONNECT_ENABLED" = "true" ]; then
        echo "Starting Spark master with Spark Connect server..."

        # Determine Spark configuration directory
        CONF_DIR="${SPARK_CONF_DIR:-${SPARK_HOME}/conf}"

        # Create required directories
        mkdir -p /tmp/spark-events /tmp/spark-warehouse

        # Configure Hive metastore URI if provided
        if [ -n "$BERDL_HIVE_METASTORE_URI" ]; then
            echo "Configuring Hive metastore: $BERDL_HIVE_METASTORE_URI"
            echo "hive.metastore.uris=$BERDL_HIVE_METASTORE_URI" >> "$CONF_DIR/spark-defaults.conf"
        fi

        # Configure MinIO S3 if credentials provided (server-side fallback for metastore operations)
        if [ -n "$MINIO_ENDPOINT_URL" ] && [ -n "$MINIO_ACCESS_KEY" ] && [ -n "$MINIO_SECRET_KEY" ]; then
            echo "Configuring MinIO S3: $MINIO_ENDPOINT_URL"
            echo "spark.hadoop.fs.s3a.endpoint=http://$MINIO_ENDPOINT_URL" >> "$CONF_DIR/spark-defaults.conf"
            echo "spark.hadoop.fs.s3a.access.key=$MINIO_ACCESS_KEY" >> "$CONF_DIR/spark-defaults.conf"
            echo "spark.hadoop.fs.s3a.secret.key=$MINIO_SECRET_KEY" >> "$CONF_DIR/spark-defaults.conf"
        fi

        # Start master in background (use nohup to detach)
        SPARK_NO_DAEMONIZE=false nohup "$SPARK_HOME/sbin/start-master.sh" > /tmp/spark-master.log 2>&1 &

        # Wait for master to be ready
        echo "Waiting for Spark master to be ready..."
        for i in $(seq 1 30); do
            if grep -q "Successfully started service 'sparkMaster'" /tmp/spark-master.log 2>/dev/null; then
                echo "Spark master is ready!"
                break
            fi
            sleep 1
        done

        # Start Spark Connect server in foreground
        echo "Starting Spark Connect server on port ${SPARK_CONNECT_PORT:-15002}..."
        exec "$SPARK_HOME/sbin/start-connect-server.sh" \
            --master "spark://$(hostname):${SPARK_MASTER_PORT:-7077}" \
            --port "${SPARK_CONNECT_PORT:-15002}"
    else
        # Start master normally in foreground
        exec "$SPARK_HOME/sbin/start-master.sh"
    fi

elif [ "$SPARK_MODE" = "worker" ]; then
    [ -z "$SPARK_MASTER_URL" ] && { echo "Error: SPARK_MASTER_URL required for worker mode"; exit 1; }
    exec "$SPARK_HOME/sbin/start-worker.sh" "$SPARK_MASTER_URL"

else
    echo "Error: SPARK_MODE must be 'master' or 'worker'"
    exit 1
fi