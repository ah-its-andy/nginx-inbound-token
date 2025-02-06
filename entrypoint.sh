#!/bin/bash

# Ensure required environment variables are set
if [[ -z "$X_INBOUND_TOKEN" || -z "$PROXY_PASS_TARGET" ]]; then
  echo "Error: X_INBOUND_TOKEN and PROXY_PASS_TARGET must be set"
  exit 1
fi

# Generate nginx configuration
echo "server {
    listen 80;

    location / {
        if (\$http_x_in_bound_token != \"$X_INBOUND_TOKEN\") {
            return 404;
        }

        proxy_pass $PROXY_PASS_TARGET;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection \"Upgrade\";
    }
}" > /etc/nginx/conf.d/default.conf

# Start Nginx in foreground
exec nginx -g "daemon off;"
