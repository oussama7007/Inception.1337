FROM debian:bullseye

RUN apt-get update && apt-get install -y mariadb-server

# Copy our custom configuration and startup script
COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY tools/setup.sh /usr/local/bin/setup.sh

# Make the script executable
RUN chmod +x /usr/local/bin/setup.sh

EXPOSE 3306

# Run the setup script when the container starts
ENTRYPOINT ["/usr/local/bin/setup.sh"]
CMD ["mysqld"]
