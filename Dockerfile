FROM ubuntu:16.04
ARG DEBIAN_FRONTEND=noninteractive
ENV LANG en_US.UTF-8
ENV NODE_ENV="production"

# please add new apt packages into the file pkg_to_install alongside this Dockerfile
ADD pkg_to_install get-pip.py /tmp/
RUN apt-get update && \
    apt-get -fy install && \
    apt-get install -y `cat /tmp/pkg_to_install` && \
    locale-gen en_US.UTF-8 && \
    update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 && \
    add-apt-repository ppa:git-core/ppa && \
    add-apt-repository ppa:deadsnakes/ppa && \
    apt-get update && \
    curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash && \
    curl -o /tini https://github.com/krallin/tini/releases/download/v0.18.0/tini &&\
    chmod +x /tini && \
    apt-get install git-lfs && \
    git lfs install && \
    apt-get install -y git python3.7 language-pack-fr && \
    update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.7 2 && \
    update-alternatives --set  python3 /usr/bin/python3.7 && \
    python3 /tmp/get-pip.py && \
    curl -sL https://deb.nodesource.com/setup_8.x | bash - && \
    apt-get install -y nodejs && \
    useradd -ms /bin/bash android && \
    git clone https://github.com/c9/core.git /cloud9 && \
    chown -R android /cloud9 && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    mkdir /workspace

ENV USER android
USER android
RUN cd /cloud9 && scripts/install-sdk.sh && \
    sed -i -e 's_127.0.0.1_0.0.0.0_g' /cloud9/configs/standalone.js

VOLUME /workspace
EXPOSE 80
ENTRYPOINT ["/usr/bin/node", "/cloud9/server.js", "--listen 0.0.0.0", "--port", "8080", "-w", "/workspace"]
# frontend should manage auth!
