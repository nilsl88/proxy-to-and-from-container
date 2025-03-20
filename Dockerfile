# Use Alpine Linux as the base image
FROM alpine:latest

# Install socat and bash in a single layer
RUN apk add --no-cache socat bash

# Set the working directory
WORKDIR /app

# Copy the script and set executable permission in one step
COPY proxy-port.sh /app/proxy-port.sh

# Make the script executable
RUN chmod +x /app/proxy-port.sh

# Set the script as the entrypoint
ENTRYPOINT ["/app/proxy-port.sh"]
