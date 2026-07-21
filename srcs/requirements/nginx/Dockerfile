FROM debian:bullseye

# Update packages and install NGINX and OpenSSL
RUN apt-get update && apt-get install -y nginx openssl

# Create a directory for the SSL certificates
RUN mkdir -p /etc/nginx/ssl

# Generate the SSL certificate for HTTPS
RUN openssl req -x509 -nodes -out /etc/nginx/ssl/inception.crt -keyout /etc/nginx/ssl/inception.key -subj "/C=MA/ST=BeniMellal/L=Khouribga/O=42/OU=1337/CN=oait-si-.42.fr/UID=oait-si-"

# Create a directory to store nginx runtime files
RUN mkdir -p /var/run/nginx

# Copy your custom NGINX configuration file from the conf folder
COPY conf/nginx.conf /etc/nginx/nginx.conf

# Expose the HTTPS port
EXPOSE 443

# Run NGINX in the foreground
CMD ["nginx", "-g", "daemon off;"]
