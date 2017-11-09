# docker_single_container_test

### VOLUMES
reference: https://docs.docker.com/engine/admin/volumes/volumes/#differences-between--v-and---mount-behavior

create a volume with:   `docker volume create custom-config-vol`

verify using list and inspect:      `docker volume ls`, `docker volume inspect custom-config-vol`

Start a container with a volume
If you start a container with a volume that does not yet exist, Docker creates the volume for you. The following example mounts the volume myvol2 into /app/ in the container.


### BUILD
`docker build -t docker_single_container_test .`
`docker build -t docker_single_container_test .`

### RUN

`docker run -p 3000:3000 -p 4000:80  --env-file ./main.env  -e RAILS_ENV=production -v /Users/fabioros/moku/docker/depop/volumes:/custom_configurations docker_single_container_test:latest`
