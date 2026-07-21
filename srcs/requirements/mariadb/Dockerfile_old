


# i use debian bullseye as the base image for my MariaDB container. All the other instructions build on top of this image.

FROM debian:bullseye

#this is executed during th image build.
#installs the mariaDB sever package -y means automatically answer yes to installation questions
#The software installation is part of building the image. The startup script is for runtime initialization and configuration. I don't want to reinstall MariaDB every time the container starts.

RUN apt-get update && apt-get install -y mariadb-server





#I copy my custom MariaDB configuration into the MariaDB configuration directory inside the image, so MariaDB uses my project-specific settings.
# Copy our custom configuration and startup script
COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY tools/setup.sh /usr/local/bin/setup.sh

# Make the script executable
RUN chmod +x /usr/local/bin/setup.sh


#This container is expected to listen on port 3306
EXPOSE 3306

# Run the setup script when the container starts
ENTRYPOINT ["/usr/local/bin/setup.sh"]
CMD ["mysqld"]
