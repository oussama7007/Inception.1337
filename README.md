# Inception

> A 42 School project introducing Docker, containerization, networking,
> and service orchestration using **Nginx**, **WordPress (PHP-FPM)**,
> **MariaDB**, and **Docker Compose**.

> **Note:** This README is a polished and organized version of the
> concepts provided in the project notes.

------------------------------------------------------------------------

# Table of Contents

-   Project Overview
-   Docker Fundamentals
-   Containers vs Virtual Machines
-   Docker Images
-   Docker Containers
-   Linux Groups
-   Docker Daemon
-   Docker Group
-   Dockerfile
-   Docker Compose
-   YAML
-   Networking
-   Volumes
-   Environment Variables vs Docker Secrets
-   Project Architecture
-   WordPress
-   MariaDB
-   Nginx
-   Request Lifecycle
-   TLS
-   docker-compose.yml Breakdown
-   Important Docker Concepts

------------------------------------------------------------------------

# Project Overview

The goal of **Inception** is to build a complete web infrastructure
using Docker.

Instead of installing software directly on the operating system, every
service runs inside its own isolated container.

The project consists of three main services:

-   **Nginx** -- Web server and reverse proxy
-   **WordPress** -- PHP application running with PHP-FPM
-   **MariaDB** -- Database server

These services communicate through a custom Docker network while storing
persistent data in Docker volumes.

------------------------------------------------------------------------

# Docker Fundamentals

## What is Docker?

Docker is a platform that packages applications together with everything
they need to run into lightweight, isolated environments called
**containers**.

A container includes:

-   Application code
-   Runtime
-   Libraries
-   Dependencies
-   Configuration files

Because everything required is packaged together, applications behave
the same on every machine, eliminating the classic *"works on my
machine"* problem.

------------------------------------------------------------------------

## Why Docker?

Without Docker:

-   Every developer installs software manually.
-   Different operating systems behave differently.
-   Dependency versions conflict.
-   Deployment becomes difficult.

With Docker:

-   Identical environments everywhere.
-   Reproducible builds.
-   Portable applications.
-   Better isolation between services.

------------------------------------------------------------------------

# Containers vs Virtual Machines

  Containers              Virtual Machines
  ----------------------- ---------------------------------
  Share the host kernel   Include a full operating system
  Lightweight             Heavy
  Fast startup            Slow startup
  Low resource usage      Higher resource usage

Containers isolate processes while sharing the host kernel, making them
much more efficient than virtual machines.

------------------------------------------------------------------------

# Docker Images

A **Docker image** is a **read-only template** used to create
containers.

It contains:

-   Application code
-   Runtime
-   Libraries
-   System tools
-   Configuration

Images are immutable.

Containers are created from images.

------------------------------------------------------------------------

# Docker Containers

A Docker container is a running instance of a Docker image.

Containers:

-   run applications
-   isolate processes
-   share the host kernel
-   can be created, stopped, removed and recreated

------------------------------------------------------------------------

# Linux Groups

Linux permissions are based on:

-   User
-   Group
-   Others

A group is simply a collection of users sharing the same permissions.

Think of a Linux group as a VIP access list.

------------------------------------------------------------------------

# Docker Daemon

Docker runs a background service called **dockerd**.

The Docker daemon is responsible for:

-   building images
-   creating containers
-   creating networks
-   creating volumes
-   communicating with the Linux kernel

Since these operations affect the operating system, the daemon runs as
**root**.

------------------------------------------------------------------------

# Docker Group

By default, normal users cannot communicate with the Docker daemon.

Docker automatically creates a Linux group named **docker**.

Adding yourself to this group:

``` bash
sudo usermod -aG docker <username>
```

allows Docker commands to be executed without using `sudo`.

------------------------------------------------------------------------

# Dockerfile

A Dockerfile is a text file containing instructions used to build a
custom Docker image.

Example:

``` dockerfile
FROM debian:bookworm

RUN apt update && apt install -y nginx

COPY . /app

CMD ["nginx","-g","daemon off;"]
```

------------------------------------------------------------------------

# Docker Compose

Docker Compose manages multiple containers as one application.

Instead of starting every service manually:

``` bash
docker compose up
```

builds images, creates containers, networks, volumes and starts every
service.

------------------------------------------------------------------------

# YAML

YAML stands for:

> YAML Ain't Markup Language

Docker Compose uses YAML because it is clean and human-readable.

Example:

``` yaml
services:
  nginx:
    image: nginx

  mariadb:
    image: mariadb
```

YAML is also used by:

-   Kubernetes
-   GitHub Actions
-   Ansible

------------------------------------------------------------------------

# Networking

The Inception subject requires creating a **custom bridge network**.

Why?

-   Better isolation.
-   Explicit configuration.
-   Automatic DNS resolution.

Containers communicate using service names instead of IP addresses.

Example:

    WordPress
         │
         ▼
     MariaDB

WordPress simply connects to:

    mariadb

Docker automatically resolves the hostname.

------------------------------------------------------------------------

# Volumes

Containers are temporary.

Deleting a container removes everything stored inside it.

Docker volumes store data outside containers, allowing it to survive
container recreation.

This project typically uses:

## MariaDB Volume

Stores:

-   databases
-   tables
-   users

## WordPress Volume

Stores:

-   uploads
-   plugins
-   themes
-   website files

------------------------------------------------------------------------

# Environment Variables vs Docker Secrets

## Environment Variables

Useful for:

-   usernames
-   database names
-   ports
-   configuration

Not recommended for sensitive production credentials.

## Docker Secrets

Used for:

-   passwords
-   certificates
-   private keys

Secrets provide a more secure way of handling confidential information.

------------------------------------------------------------------------

# Architecture

               Internet
                   │
                   ▼
            +--------------+
            |    Nginx     |
            +--------------+
                   │
                   ▼
            +--------------+
            |  WordPress   |
            |   PHP-FPM    |
            +--------------+
                   │
                   ▼
            +--------------+
            |   MariaDB    |
            +--------------+

------------------------------------------------------------------------

# WordPress

WordPress is a free and open-source Content Management System (CMS).

It allows users to:

-   publish pages
-   write blog posts
-   install plugins
-   manage themes
-   upload media

It stores all persistent information inside MariaDB.

------------------------------------------------------------------------

# MariaDB

MariaDB is an open-source relational database.

It stores:

-   users
-   posts
-   comments
-   pages
-   settings
-   plugins
-   themes

Without MariaDB, WordPress has no persistent data.

------------------------------------------------------------------------

# Nginx

Nginx is a high-performance web server and reverse proxy.

In this project it:

-   accepts HTTPS requests
-   terminates TLS
-   serves static files
-   forwards PHP requests to PHP-FPM

Only Nginx is exposed to the outside world.

------------------------------------------------------------------------

# Request Lifecycle

    Browser
       │
       ▼
     Nginx
       │
       ▼
    WordPress
       │
       ▼
    MariaDB

1.  Browser sends HTTPS request.
2.  Nginx receives it.
3.  PHP requests are forwarded to WordPress.
4.  WordPress queries MariaDB if data is required.
5.  HTML is generated.
6.  Nginx returns the response to the browser.

------------------------------------------------------------------------

# TLS

TLS (Transport Layer Security) secures communication between clients and
servers.

It provides:

-   Confidentiality
-   Integrity
-   Authentication

TLS replaces SSL and modern deployments should use TLS 1.2 or TLS 1.3.

------------------------------------------------------------------------

# docker-compose.yml Breakdown

``` yaml
version: "3"

services:
  mariadb:
    build:
      context: ./requirements/mariadb
    networks:
      - inception_network
    volumes:
      - mariadb_data:/var/lib/mysql

  wordpress:
    build:
      context: ./requirements/wordpress
    networks:
      - inception_network
    volumes:
      - wordpress_data:/var/www/html

  nginx:
    build:
      context: ./requirements/nginx
    ports:
      - "443:443"
    networks:
      - inception_network
    volumes:
      - wordpress_data:/var/www/html

networks:
  inception_network:
    driver: bridge

volumes:
  mariadb_data:
  wordpress_data:
```

### Explanation

-   **version** -- Compose file format.
-   **services** -- List of containers.
-   **build** -- Build a custom image.
-   **context** -- Build directory.
-   **container_name** -- Fixed container name.
-   **restart: always** -- Restart automatically.
-   **ports** -- Host-to-container port mapping.
-   **networks** -- Attach services to the custom bridge.
-   **volumes** -- Persistent storage.

------------------------------------------------------------------------

# Important Docker Concepts

## Why not use the `latest` tag?

Using `latest` makes builds unpredictable.

Always pin specific versions to ensure reproducible builds.

## Why use `exec`?

The main process inside a container should become PID 1.

Using:

``` bash
exec nginx -g "daemon off;"
```

allows Docker to correctly handle signals.

Using:

``` bash
tail -f /dev/null
sleep infinity
```

only keeps the container alive artificially and is considered bad
practice.

## Why PHP-FPM?

PHP-FPM executes PHP scripts.

It is **not** a web server.

Nginx receives HTTP requests and forwards PHP scripts to PHP-FPM.

------------------------------------------------------------------------

# Summary

This project demonstrates:

-   Docker
-   Containers
-   Images
-   Dockerfiles
-   Docker Compose
-   Custom bridge networks
-   Volumes
-   TLS
-   Nginx
-   WordPress
-   MariaDB
-   Multi-container architecture
-   Persistent storage
-   Service isolation
-   Inter-container communication

Together, these technologies create a secure, modular, reproducible web
infrastructure.
