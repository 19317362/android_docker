FROM ubuntu:16.04
ARG DEBIAN_FRONTEND=noninteractive
ENV LANG en_US.UTF-8
# please add new apt packages into the file pkg_to_install alongside this Dockerfile
ADD pkg_to_install get-pip.py /tmp/
RUN apt-get update && \
    apt-get -fy install && \
    apt-get install -y `cat /tmp/pkg_to_install` && \
    locale-gen en_US.UTF-8 && \
    update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 && \
    add-apt-repository ppa:git-core/ppa && \
    add-apt-repository ppa:jonathonf/python-3.7 && \
    apt-get update && \
    curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash && \
    apt-get install git-lfs && \
    git lfs install && \
    apt-get install -y git python3.6 language-pack-fr && \
    update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.6 2 && \
    update-alternatives --set  python3 /usr/bin/python3.6 && \
    python3 /tmp/get-pip.py && \
    useradd -ms /bin/bash android && \
    rm -rf /tmp/* /var/lib/apt/lists/*
ENV USER android
USER android