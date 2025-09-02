FROM ghcr.io/berdatalakehouse/spark_notebook:main
USER root
COPY ./scripts/ /opt/scripts/
RUN chmod +x -R /opt/scripts/
ENTRYPOINT ["tini", "-v", "--", "/opt/scripts/entrypoint.sh"]
