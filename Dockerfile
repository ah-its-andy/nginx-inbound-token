FROM nginx:latest

# Declare environment variables
ENV X_INBOUND_TOKEN="default-token" \
    PROXY_PASS_TARGET="http://backend-service"

# Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set entrypoint
ENTRYPOINT ["/entrypoint.sh"]
