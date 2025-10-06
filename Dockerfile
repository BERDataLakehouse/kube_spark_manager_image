FROM ghcr.io/berdatalakehouse/spark_notebook:main
ARG SPARK_HOME=/usr/local/spark
USER root
COPY ./scripts/ /opt/scripts/
COPY ./configs/spark-defaults.conf ${SPARK_HOME}/conf/spark-defaults.conf
RUN chmod +x -R /opt/scripts/
ENTRYPOINT ["tini", "-v", "--", "/opt/scripts/entrypoint.sh"]
