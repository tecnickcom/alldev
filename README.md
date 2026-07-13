# alldev

*Dockerfile to build linux-based generic development environments*

[![Sponsor on GitHub](https://img.shields.io/badge/sponsor-github-EA4AAA.svg?logo=githubsponsors&logoColor=white)](https://github.com/sponsors/tecnickcom)

If this project is useful to you, please consider [supporting development via GitHub Sponsors](https://github.com/sponsors/tecnickcom).

* **category**    Docker
* **author**      Nicola Asuni <info@tecnick.com>
* **copyright**   2016-2026 Nicola Asuni - Tecnick.com LTD
* **license**     MIT (see LICENSE)
* **link**        https://github.com/tecnickcom/alldev
* **docker**      https://hub.docker.com/r/tecnickcom/alldev/

## Description

Source configuration files to build Docker images with different development environment.

The generated Docker images are available at https://hub.docker.com/r/tecnickcom/


## Requirements

This script requires Docker (https://www.docker.com/).
To install Docker in a debian or Ubuntu OS:
```
sudo apt-get install docker docker.io
```
Add your user to the "docker" group:
```
sudo groupadd docker
sudo gpasswd -a <YOURUSER> docker
sudo service docker restart
```



## Getting started

This project include a Makefile that allows you to automate common operations.
To see all available options:
```
make help
```
To build an image:
```
make build DIMG=<IMAGE_DIR>
```


## Useful Docker commands

To log into the newly created container:
```
docker run -t -i tecnickcom/alldev /bin/bash
```

To get the container ID:
```
CONTAINER_ID=`docker ps -a | grep tecnickcom/alldev | cut -c1-12`
```

To delete the newly created docker container:
```
docker rm -f $CONTAINER_ID
```

To delete the docker image:
```
docker rmi -f tecnickcom/alldev
```

To delete all containers
```
docker rm -f $(docker ps -a -q)
```

To delete all images
```
docker rmi -f $(docker images -q)
```


## Docker-in-Docker (DooD, dind)

To run Docker in docker in with the provided gocd-agent images,
the docker socket must be mounted:
```
/var/run/docker.sock:/var/run/docker.sock
```
and the container must run in privileged mode.


## Developer(s) Contact

* Nicola Asuni <info@tecnick.com>
