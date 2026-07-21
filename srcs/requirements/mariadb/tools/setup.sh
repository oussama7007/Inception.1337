#!/bin/bash

# Only run setup if the database doesn't already exist in the volume
if [ ! -d "/var/lib/mysql/${DB_NAME}" ]; then
    
    echo "Initializing database for the first time..."
    service mariadb start
    
    # Wait for MariaDB to be fully ready
    sleep 3 
    
    mysql -e "CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\`;"
    mysql -e "CREATE USER IF NOT EXISTS \`${DB_USER}\`@'%' IDENTIFIED BY '${DB_PASSWORD}';"
    mysql -e "GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO \`${DB_USER}\`@'%';"
    mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}';"
    mysql -u root -p"${DB_ROOT_PASSWORD}" -e "FLUSH PRIVILEGES;"
    
    # Shut down the temporary background service cleanly
    mysqladmin -u root -p"${DB_ROOT_PASSWORD}" shutdown

else
    echo "Database already initialized. Skipping setup..."
fi

# Execute the command passed from the Dockerfile CMD (mysqld_safe)
exec "$@"
