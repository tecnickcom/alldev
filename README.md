# alldev

*Dockerfile to build a generic development environment based on Ubuntu Linux*

[![Donate via PayPal](https://img.shields.io/badge/donate-paypal-87ceeb.svg)](https://www.paypal.com/cgi-bin/webscr?cmd=_donations&currency_code=GBP&business=paypal@tecnick.com&item_name=donation%20for%20alldev%20project)
*Please consider supporting this project by making a donation via [PayPal](https://www.paypal.com/cgi-bin/webscr?cmd=_donations&currency_code=GBP&business=paypal@tecnick.com&item_name=donation%20for%20alldev%20project)*

* **category**    Docker
* **author**      Nicola Asuni <info@tecnick.com>
* **copyright**   2016-2016 Nicola Asuni - Tecnick.com LTD
* **license**     http://www.gnu.org/copyleft/lesser.html GNU-LGPL v3 (see LICENSE)
* **link**        https://github.com/tecnickcom/alldev
* **docker**      https://hub.docker.com/r/tecnickcom/alldev/

## Description

Source configuration file to build a Docker container image with a generic development environment.

The generated Docker image, available at https://hub.docker.com/r/tecnickcom/alldev/, 
is quite large and it is intended to provide a ready-made development environment for different languages and technologies.


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
To build the project
```
make build
```

## Useful Docker commands

To manually create the container you can execute:
```
docker build --tag="tecnickcom/alldev" .
```

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
docker rm $(docker ps -a -q)
```

To delete all images
```
    docker rmi $(docker images -q)
```

## Developer(s) Contact

* Nicola Asuni <info@tecnick.com>
