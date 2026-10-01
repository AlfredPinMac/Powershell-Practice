FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    iproute2 \
    iputils-ping \
    traceroute \
    dnsutils \
    tcpdump \
    tshark \
    net-tools \
    netcat-openbsd \
    curl \
    wget \
    nano \
    vim \
    && rm -rf /var/lib/apt/lists/*

# Allow tshark/Wireshark packet capture without requiring an interactive prompt
RUN setcap cap_net_raw,cap_net_admin=eip /usr/bin/dumpcap || true

WORKDIR /lab

# Copy the script and make it executable
COPY check_port.sh /lab/check_port.sh
RUN chmod +x /lab/check_port.sh

CMD ["/bin/bash"]

