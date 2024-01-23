# Biomedisa Installation

Since a stable installation of biomedisa requires a number of software packages
as underlying dependencies we propose to take the container approach to deploy
it in a linux environment leveraging GPU computing. For that we need to prepare
the platform with the following software tools.

- [Docker Engine on Linux](https://docs.docker.com/engine/install/)
- [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html#)

Following are related references:

- [Biomedisa](https://github.com/biomedisa/biomedisa)
- [Host-installation Instructions](https://github.com/biomedisa/biomedisa/blob/master/README/ubuntu2204_cuda11.8.md)

This repository hosts the recipe for the container orchestration to deploy the
biomedisa frontend and the underlying MySQL database server.

**NOTE**: We need to create a directory to host the database contents, which in
this instance, we call *data*. This is not put into version control. Also, we
need to think about the necessary settings and concerning networking and security.

We also need to keep in mind to execute the container orchestration in the following
manner.

```bash
$ docker-compose build --progress plain
$ docker-compose up
# And when not needed
$ docker-compose down
```

This is recommended because with exhaustive testing we observed that the command
`docker-compose up --build` not always working as expected.

Moreover, to facilitate the CLI intrface a conveninent command line function
needs to be devised.
