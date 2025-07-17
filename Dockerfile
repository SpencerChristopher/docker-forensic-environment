FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive

# Define build arguments for user credentials
ARG TARGET_USER=ubu
ARG TARGET_PASSWORD=1234

# Install essential packages and add PPAs for forensic tools and Firefox
RUN apt-get update && \
    # Install prerequisites for adding PPAs and other tools
    apt-get install -y --no-install-recommends software-properties-common gnupg wget unzip && \
    # Add GIFT PPA for forensic tools (Plaso, etc.)
    add-apt-repository -y ppa:gift/stable && \
    # Add Mozilla PPA for the latest Firefox .deb package
    add-apt-repository -y ppa:mozillateam/ppa && \
    # Configure APT to prioritize Mozilla's Firefox
    echo 'Package: *' > /etc/apt/preferences.d/mozilla-firefox && \
    echo 'Pin: release o=LP-PPA-mozillateam' >> /etc/apt/preferences.d/mozilla-firefox && \
    echo 'Pin-Priority: 1001' >> /etc/apt/preferences.d/mozilla-firefox && \
    # Pre-configure wireshark-common to allow non-root capture
    echo "wireshark-common wireshark-common/install-setuid boolean true" | debconf-set-selections && \
    apt-get update && \
    # Install desktop, RDP tools, browser, and forensic tools
    apt-get install -y --no-install-recommends \
        lubuntu-desktop \
        xrdp \
        xorgxrdp \
        lxsession \
        sudo \
        firefox \
        sleuthkit \
        plaso-tools \
        wireshark \
        mono-complete && \
    # Create user and set password
    useradd -m -s /bin/bash ubu && \
    echo "ubu:1234" | chpasswd && \
    usermod -aG sudo,wireshark ubu && \
    # Create a shared workspace and set permissions
    mkdir -p /shared/workspace && \
    chown -R ubu:ubu /shared/workspace && \
    # Clean up
    rm -rf /var/lib/apt/lists/*

# Download and install NetworkMiner
RUN cd /opt && \
    wget https://sourceforge.net/projects/networkminer/files/latest/download -O NetworkMiner.zip && \
    unzip NetworkMiner.zip && \
    rm NetworkMiner.zip && \
    chmod +x /opt/NetworkMiner*/NetworkMiner.exe

# Configure XRDP session
RUN echo "startlxqt" > /home/${TARGET_USER}/.xsession && \
    chown ${TARGET_USER}:${TARGET_USER} /home/${TARGET_USER}/.xsession && \
    adduser xrdp ssl-cert && \
    mkdir -p /var/run/xrdp-sesman

# Start services
CMD ["/bin/bash", "-c", "rm -f /var/run/xrdp/*.pid /var/run/xrdp-sesman.pid && /usr/sbin/xrdp-sesman && exec /usr/sbin/xrdp --nodaemon"]