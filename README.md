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
Your Compose file creates this architecture:

                         Internet
                             │
                             ▼
                       Port 443
                             │
                             ▼
                     ┌─────────────┐
                     │    Nginx    │
                     └─────────────┘
                             │
                             ▼
                   inception_network
                             │
                             ▼
                     ┌─────────────┐
                     │  WordPress  │
                     └─────────────┘
                             │
                             ▼
                     ┌─────────────┐
                     │   MariaDB   │
                     └─────────────┘
Host Machine
│
├── /home/oait-si-/data/mariadb
│       └── MariaDB data
│
└── /home/oait-si-/data/wordpress
        └── WordPress files




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








What is TLS?

TLS (Transport Layer Security) is a cryptographic protocol that secures communication between a client (such as a web browser) and a server.

Its main goals are to provide:

Confidentiality – data is encrypted so that no one can read it.
Integrity – data cannot be modified without detection.
Authentication – the client can verify that it is communicating with the correct server.

TLS is the modern replacement for SSL (Secure Sockets Layer).

Why do we need TLS?

Without TLS:

Browser  -------------------->  Server
          Plain text

An attacker on the network could read everything being transmitted, including:

Usernames
Passwords
Cookies
Personal information

With TLS:

Browser  ==== Encrypted ====►  Server

Even if someone intercepts the traffic, they only see encrypted data.

How does TLS work?

When a browser connects to:

https://yourdomain.com

it performs a TLS handshake with the server.

During this handshake:

The server proves its identity by presenting a certificate.
The browser verifies the certificate.
Both sides agree on encryption keys.
All subsequent communication is encrypted.
What files does Nginx need?

Nginx needs two cryptographic files.

1. Certificate (.crt or .pem)

Example:

server.crt

This file contains the server's public certificate.

Its purpose is to:

Identify the server.
Allow the browser to verify the server's identity.
Contain the server's public key (or reference to it, depending on the certificate format).
2. Private Key (.key)

Example:

server.key

This file contains the server's private key.

It is used to:

Prove ownership of the certificate.
Decrypt parts of the TLS handshake.
Establish secure session keys.

This file must remain secret.

How does Nginx use them?

In your Nginx configuration:

ssl_certificate     /etc/nginx/ssl/server.crt;
ssl_certificate_key /etc/nginx/ssl/server.key;

When a browser connects:

Browser
     │
 HTTPS
     ▼
 Nginx
 ├── server.crt
 └── server.key

Nginx uses these files during the TLS handshake.


In the Inception project

You usually generate a self-signed certificate because you don't own a certificate issued by a public Certificate Authority (CA).


A common command is:

openssl req -x509 -nodes -days 365 \
  -newkey rsa:2048 \
  -keyout server.key \
  -out server.crt

This generates:

server.crt
server.key

These files are then mounted into the Nginx container and referenced in nginx.conf.


NGINX Configuration (nginx.conf) Explained
This section breaks down the core configuration used to securely route traffic and serve the WordPress site within our Docker architecture.

1. Global Context & Web Traffic
events {}: A mandatory block required by NGINX to know how to handle connection processing, even if left empty.

http {}: Defines that all configurations within this block pertain to web traffic (HTTP/HTTPS).

include /etc/nginx/mime.types;: Instructs NGINX on how to properly identify and serve different file types (e.g., .css for stylesheets, .js for scripts, and image formats). Without this, the website would load as unstyled plain text.

2. Server & Security Setup
server {}: Defines the specific configuration and routing rules for our website.

listen 443 ssl;: Ensures NGINX only listens on port 443 (HTTPS) and strictly applies SSL/TLS encryption. Port 80 (unencrypted HTTP) is completely disabled.

server_name oait-si-.42.fr;: Restricts NGINX to only respond when the user navigates to this specific domain name.

ssl_protocols TLSv1.2 TLSv1.3;: Enforces the use of modern, secure TLS protocols.

ssl_certificate & ssl_certificate_key: Points NGINX to the generated public certificate and private key inside the container (/etc/nginx/ssl/) to authenticate the server and encrypt the connection.

3. File Routing (Document Root)
root /var/www/html;: Defines the absolute path inside the container where the website files are located. This path is mapped to the WordPress volume.

index index.php index.html index.htm;: Sets the default fallback files NGINX should look for when a user accesses the domain without specifying a specific page.

location / { try_files $uri $uri/ =404; }: When a standard URL is requested, NGINX checks if the specific file ($uri) or directory ($uri/) exists. If neither can be found, it returns a standard 404 Not Found error.

4. The PHP Handoff (FastCGI)
location ~ \.php$ {}: A regex block that intercepts any request ending in .php. It tells NGINX not to attempt to read or serve the PHP code as plain text.

fastcgi_pass wordpress:9000;: Forwards the packaged PHP request over the internal Docker network to port 9000 of the container named wordpress, where PHP-FPM will actually execute the code.














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
