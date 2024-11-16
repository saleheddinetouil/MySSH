FROM ubuntu:latest

# Install SSH server and other necessary packages
RUN apt-get update -y -qq && \
    apt-get install -y -qq openssh-server sudo

# Create user and set password (CHANGE THIS!)
RUN useradd -m saleh && \
    echo "saleh:Saleh2024@" | chpasswd

# Set up SSH key (copy your public key)
RUN mkdir -p /home/saleh/.ssh && \
    chmod 700 /home/saleh/.ssh && \
    touch /home/saleh/.ssh/authorized_keys && \
    chmod 600 /home/saleh/.ssh/authorized_keys && \
    # Use a heredoc to add the key from the repo secret (more secure)
    tee /home/saleh/.ssh/authorized_keys > /dev/null <<EOF
${{ secrets.SSH_PUBLIC_KEY }} # Access public key from GitHub secrets
EOF


# Disable password authentication
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config

# Expose SSH port
EXPOSE 2222

# Start SSH server with proper initialization for Systemd
CMD ["/usr/sbin/sshd", "-D", "-e"]