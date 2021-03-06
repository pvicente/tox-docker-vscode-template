FROM ubuntu:18.04

# Set the default shell to bash instead of sh
ENV SHELL /bin/bash

# http://bugs.python.org/issue19846
# > At the moment, setting "LANG=C" on a Linux system *fundamentally breaks Python 3*, and that's not OK.
ENV LANG C.UTF-8

# Install python versions from deadsnakes used in Linux CI
RUN . /etc/os-release && \
    apt-get update && \
    apt-get install -y gnupg && \
    echo "deb http://ppa.launchpad.net/deadsnakes/ppa/ubuntu ${UBUNTU_CODENAME} main" > /etc/apt/sources.list.d/deadsnakes.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys F23C5A6CF475977595C89F51BA6932366A755776 && \
    apt-get update && \
    apt-get install -y \
        python-pip python3-pip \
        \
        python2.7 python2.7-dev \
        python3.[4,5,6,7] python3.[4,5,6,7]-dev \
    && \
    apt-get --purge autoremove -y gnupg && \
    apt-get clean -y && \
    rm -rf /var/cache/apt/lists/*

# Install git, procps (process tools needed by vscode remote)
# gcc and ca-cert needed to install dev envs. Do clean up at the end
RUN apt-get update && \
    apt-get install -y \
        git procps \
        gcc ca-cacert \
        vim htop \
    && \
    apt-get --purge autoremove -y && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/*

# Create devuser to run everything as normal user. ARG uid passed as build time
ARG uid=1000
RUN useradd -u${uid} -s${SHELL} -m devuser
ENV HOME /home/devuser

# [Optional] Add sudo support
RUN apt-get update && \
    apt-get install -y sudo && \
    apt-get --purge autoremove -y && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/* && \
    echo devuser ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/devuser && \
    chmod 0440 /etc/sudoers.d/devuser && \
    getent passwd devuser

# Upgrade pip and install tox
RUN python3.7 -m pip install --upgrade pip && python3.7 -m pip install tox

COPY create_dev_env.bash /usr/local/bin/create_dev_env.bash
RUN chmod +x /usr/local/bin/create_dev_env.bash

# Set the default user
USER devuser

# For some reason terminal opened inside vscode is settings LANG='en_US.UTF8' and some tests
# are failing because of http://bugs.python.org/issue19846
# Set tox workdir ~/.tox by default to don't pollute the source code, keeps venvs inside container
# and install them faster (no access to mounted volume).
RUN echo "\
export LANG='C.UTF-8'\n\
alias tox='tox --workdir ~/.tox'\n\
alias create_dev_env='create_dev_env.bash'\n\
alias workon_dev='. ~/.tox/dev/bin/activate'\n\
" >> ~/.bashrc
