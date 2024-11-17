FROM alpine:latest

# Install OpenSSH client and other necessary tools
RUN apk update && apk add --no-cache openssh curl

# Set up a directory for SSH
RUN mkdir -p /root/.ssh && chmod 700 /root/.ssh

# Install and configure DuckDNS script
RUN mkdir -p /opt/duckdns
COPY duckdns.sh /opt/duckdns/duckdns.sh
RUN chmod +x /opt/duckdns/duckdns.sh

# Run DuckDNS update script periodically (e.g., every 5 minutes)
RUN echo "*/5 * * * * /opt/duckdns/duckdns.sh > /dev/null 2>&1" >> /etc/crontabs/root

# Start crond in the background and run SSH
CMD crond && /bin/sh

# Expose port 22 for SSH access
EXPOSE 22