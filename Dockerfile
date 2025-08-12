FROM ghcr.io/bio-boris/berdl_notebook:0.0.7
USER root
COPY ./scripts/ /opt/scripts/
RUN chmod +x -R /opt/scripts/
ENTRYPOINT ["tini", "-v", "--", "/opt/scripts/entrypoint.sh"]
#ENTRYPOINT ["/opt/scripts/entrypoint.sh"]

env SPARK_NO_DAEMONIZE=true