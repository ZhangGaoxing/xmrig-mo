FROM ubuntu:jammy

ENV DEBIAN_FRONTEND=noninteractive
RUN apt update
RUN apt install -y git build-essential cmake libuv1-dev libssl-dev libhwloc-dev

# build xmrig
RUN git clone https://github.com/ZhangGaoxing/xmrig-mo.git --depth=1
# enable MSR
ARG TARGETPLATFORM
RUN if [ "$TARGETPLATFORM" = "linux/amd64" ]; then \
        echo "$TARGETPLATFORM, install tools"; \
        apt install -y msr-tools kmod; \
        cd /xmrig-mo/scripts; \
        sh randomx_boost.sh; \
    else \
        echo "$TARGETPLATFORM, skip."; \
    fi
# build
WORKDIR /xmrig-mo/build
RUN cmake .. && \
    make -j$(nproc)
RUN mkdir /xmrig /xmrig/configs && \
    cp xmrig /xmrig && \
    cp config.json /xmrig/configs

# cleanup
RUN rm -rf /xmrig-mo /xmrig-cuda
RUN apt-get purge -y git build-essential cmake && \
    apt-get autoremove -y

WORKDIR /xmrig
CMD ["/xmrig/xmrig", "--config=/xmrig/configs/config.json"]
