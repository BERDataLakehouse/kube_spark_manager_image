FROM ghcr.io/berdatalakehouse/spark_notebook:main
USER root
COPY ./scripts/ /opt/scripts/
COPY ./configs/spark-defaults.conf /usr/local/spark/conf/spark-defaults.conf
RUN chmod +x -R /opt/scripts/
ENTRYPOINT ["tini", "-v", "--", "/opt/scripts/entrypoint.sh"]
