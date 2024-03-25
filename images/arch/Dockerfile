FROM archlinux:latest
RUN pacman -Sy --noconfirm && \
    pacman -Syu --noconfirm && \
    pacman -S --noconfirm neofetch sudo openssh

# Enable SSH
RUN mkdir /var/run/sshd
RUN echo 'root:containerme' | chpasswd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN ssh-keygen -A

# Copy public keys
COPY keys/* /keys/
COPY update-keys.sh /update-keys.sh

RUN chmod +x /update-keys.sh

RUN /update-keys.sh

ENTRYPOINT ["/usr/sbin/sshd", "-D"]
