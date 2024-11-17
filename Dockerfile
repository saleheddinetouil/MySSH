# Use specific version for reproducibility
FROM alpine:3.14 as builder

# Install OpenSSH client, curl, and other necessary tools
RUN apk update && apk add --no-cache openssh curl

# Set up a directory for SSH
RUN mkdir -p /root/.ssh && chmod 700 /root/.ssh

# Copy No-IP script
COPY noip.sh /opt/noip/noip.sh
RUN chmod +x /opt/noip/noip.sh

# Create a non-root user and ensure it's added to passwd file
RUN adduser -D myuser

# Use a minimal base image
FROM alpine:3.14

# Copy necessary files from the builder image
COPY --from=builder /root/.ssh /root/.ssh
COPY --from=builder /opt/noip /opt/noip
COPY --from=builder /etc/passwd /etc/passwd
COPY --from=builder /etc/group /etc/group

# Install OpenSSH client and crond
RUN apk update && apk add --no-cache openssh

# Set environment variables for No-IP credentials
ENV NOIP_USERNAME=${NOIP_USERNAME}
ENV NOIP_PASSWORD=${NOIP_PASSWORD}
ENV NOIP_HOSTNAME=${NOIP_HOSTNAME}

# Switch to non-root user
USER myuser

# Expose port 22 for SSH access
EXPOSE 22

# Add healthcheck
HEALTHCHECK --interval=30s --timeout=10s --retries=3 CMD pgrep crond || exit 1

# Start crond in the background and run SSH
ENTRYPOINT ["crond", "-f"]
CMD ["/bin/sh"]