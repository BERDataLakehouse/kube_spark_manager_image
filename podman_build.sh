 podman build . --platform=linux/amd64 --format docker -t localhost/spark/spark:test
 podman compose up -d --force-recreate --remove-orphans