FROM ubuntu:latest
RUN DEBIAN_FRONTEND=noninteractive apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get upgrade -y && \ 
    DEBIAN_FRONTEND=noninteractive apt-get install  -y neofetch sudo openssh-server

# Enable SSH
RUN mkdir /var/run/sshd
RUN echo 'root:containerme' | chpasswd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

COPY keys/* /keys/
COPY update-keys.sh /update-keys.sh

RUN chmod +x /update-keys.sh

RUN /update-keys.sh

ENTRYPOINT ["/usr/sbin/sshd", "-D"]


