# docker_single_container_test


BUILD
`docker build -t docker_single_container_test .`

RUN
`docker run -p 3000:3000 -p 4000:80 docker_single_container_test:latest`