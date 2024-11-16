FROM ubuntu:latest

RUN apt-get update -y -qq && \
    apt-get install -y -qq openssh-server sudo

RUN useradd -m saleh && \
    echo "saleh:saleh" | chpasswd # CHANGE THIS PASSWORD!

RUN mkdir -p /home/saleh/.ssh && \
    chmod 700 /home/saleh/.ssh && \
    touch /home/saleh/.ssh/authorized_keys && \
    chmod 600 /home/saleh/.ssh/authorized_keys

COPY id_rsa.pub /home/saleh/.ssh/authorized_keys 

RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config

EXPOSE 2222 # Choose a port

CMD ["/usr/sbin/sshd", "-D"]