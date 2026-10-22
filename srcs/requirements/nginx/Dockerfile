FROM debian:bookworm

RUN apt-get update -y && apt-get install -y \
    nginx \
    openssl \
    && rm -rf /var/lib/apt/lists/*

# Generate self-signed SSL/TLS certificate for your domain
RUN mkdir -p /etc/nginx/ssl \
    && openssl req -x509 -nodes -days 365 \
    -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/inception.key \
    -out /etc/nginx/ssl/inception.crt \
    -subj "/C=NL/ST=State/L=City/O=42/OU=Student/CN=qvan-der.42.fr"

COPY conf/nginx.conf /etc/nginx/conf.d/default.conf

# Foreground execution (no daemon)
ENTRYPOINT ["nginx", "-g", "daemon off;"]
