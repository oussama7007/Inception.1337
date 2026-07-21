# Use debian bullseye as the base image
FROM debian:bullseye

# Install MariaDB and clean up the apt cache to keep the image small
RUN apt-get update && \
    apt-get install -y mariadb-server && \
    rm -rf /var/lib/apt/lists/*

# Copy custom configuration and startup script
COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY tools/setup.sh /usr/local/bin/setup.sh

# Make the script executable
RUN chmod +x /usr/local/bin/setup.sh

# Expose port 3306
EXPOSE 3306

# Run the setup script, passing mysqld_safe as the final command
ENTRYPOINT ["/usr/local/bin/setup.sh"]
CMD ["mysqld_safe"]
