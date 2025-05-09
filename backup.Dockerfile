FROM alpine:edge@sha256:b93f4f6834d5c6849d859a4c07cc88f5a7d8ce5fb8d2e72940d8edd8be343c04

# Add necessary repositories, update, and install packages
RUN echo "https://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
    apk update && \
    apk add --no-cache \
        restic \
        kopia \
        borgbackup \
        neovim \
        fish \
        curl \
        openssh-client \
        jq \
        nodejs \
        npm \
        kubectl \
        python3 \
        py3-pip && \
    rm -rf /var/cache/apk/*

# Install AWS CLI via pip with the flag to override the externally-managed environment
RUN pip3 install --upgrade --break-system-packages awscli

# https://github.com/bitwarden/clients/issues/9646
#RUN npm install -g @bitwarden/cli@2024.6.0
RUN npm install -g @bitwarden/cli

# Set Fish as the default shell
ENV SHELL /usr/bin/fish

WORKDIR /

RUN echo "umask 077" >> /etc/profile
RUN mkdir -p /root/.ssh && chmod 700 /root/.ssh/

RUN kubectl version --client
RUN npm version
RUN restic version
RUN kopia --version
RUN jq --version
RUN borg --version
RUN nvim --version
RUN curl --version
RUN aws --version

# Command to run on container start
#CMD ["fish"]
