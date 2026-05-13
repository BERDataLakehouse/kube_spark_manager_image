ARG BASE_TAG=pr-188
ARG BASE_REGISTRY=ghcr.io/berdatalakehouse/
FROM ${BASE_REGISTRY}spark_notebook:${BASE_TAG}
USER root
COPY ./scripts/ /opt/scripts/
RUN chmod +x -R /opt/scripts/
ENTRYPOINT ["tini", "-v", "--", "/opt/scripts/entrypoint.sh"]
