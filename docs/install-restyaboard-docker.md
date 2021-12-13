---
description: Restyaboard installation through Docker
---

# Install Restyaboard through Docker

## Introduction

Restyaboard can be installed using the Docker Compose.

This document is a step-by-step guide that illustrates how to install the Restyaboard using Docker Compose.

### What you'll learn

*   How to install the Restyaboard using Docker Compose

## Install Restyaboard Using Docker Compose

For automated deployment management instead of using the regular Docker commands, use Docker-compose.

#### Requirements

*   [Docker](https://docs.docker.com/install "Docker")
*   [Docker Compose](https://docs.docker.com/compose/install/ "Docker Compose")

#### Latest version of Restyaboard

Download sample compose file

    curl -L https://raw.githubusercontent.com/RestyaPlatform/board/dev/docker-compose.prod.yml -o docker-compose.yml

Modify `RELAYHOST` IP with your instance’s public IP address (refer [https://github.com/RestyaPlatform/board/blob/dev/docker-compose.prod.yml#L29](https://github.com/RestyaPlatform/board/blob/dev/docker-compose.prod.yml#L29 "RELAYHOST IP"))

The default port is `1234`, if you want to modify refer [https://github.com/RestyaPlatform/board/blob/dev/docker-compose.prod.yml#L6](https://github.com/RestyaPlatform/board/blob/dev/docker-compose.prod.yml#L6 "Default Port")

Start postfix docker container (for sending emails):

    docker run -d --rm --name postfix -e "ALLOW_EMPTY_SENDER_DOMAINS=true" -p 1587:587 boky/postfix

Then, execute the below command to install the Restyaboard in docker:

    docker-compose up -d

## Launch Restyaboard Instance

Log in with the below-given default admin credentials

**Restyaboard URL:** `http://{Server IP}:1234`

**Username:** admin

**Password:** restya

**Admin Settings:** `http://{Server IP}:1234/#/settings`

## Remove Restyaboard docker

For removing the Restyaboard docker, run the below command:

    docker-compose down

#### Remove Postfix docker

For removing the Postfix docker for receiving mail notifications, run the below command:

    
    docker stop postfix
    docker rm postfix
