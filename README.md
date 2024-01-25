# Biomedisa Installation

Since a stable installation of biomedisa requires a number of software packages
as underlying dependencies we propose to take the container approach to deploy
it in a linux environment leveraging GPU computing. For that we need to prepare
the host platform with the following software tools.

- [Docker Engine on Linux](https://docs.docker.com/engine/install/)
- [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html#)

Following are related references:

- [Biomedisa](https://github.com/biomedisa/biomedisa)
- [Host-installation Instructions](https://github.com/biomedisa/biomedisa/blob/master/README/ubuntu2204_cuda11.8.md)

This repository hosts the recipe for the container orchestration to deploy the
biomedisa frontend and the underlying MySQL database server.

**NOTE**: We need to create a directory to host the database contents, which in
this instance, we call *data*. This is not put into version control. We need to
think about the necessary settings concerning networking and security as well as
considerations for single GPU vs multi-GPU systems.

Once the Docker engine and the NVIDIA Container Toolkit is installed the configuration
can be verified with the following commands.

```bash
$ docker-compose -f nvidia-test.yml build
$ docker-compose -f nvidia-test.yml up
# First command should pull and build the image if not done previously.
# Second command should execute the container. It should show the familiar
# NVIDIA System Management Interface (nvidia-smi) before exiting with code 0.
```

Following commands can be used to execute the biomedisa app.

```bash
$ docker-compose build --progress plain
$ docker-compose up
# And when not needed
$ docker-compose down
# An explicit build command with '--progress plain' flag shows the full build log
# which is useful for troubleshooting. We recommend this method of execution over
# the familiar `docker-compose up --build` method to make the detection of potential
# issues easier.
```

Moreover, once the containers are running once can facilitate the CLI intrface for
biomedisa by developing a command-line function leveraging the `docker exec -it <container> <command>`
utility.
