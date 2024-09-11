FROM alpine:latest

RUN apk update && \
    apk add --no-cache \
    restic \
    borgbackup \
    neovim \
    fish \
    curl \
    openssh-client \
    jq \
    nodejs \
    npm \
    && rm -rf /var/cache/apk/*

RUN npm install -g @bitwarden/cli

# Set Fish as the default shell
ENV SHELL /usr/bin/fish

WORKDIR /

RUN echo "umask 077" >> /etc/profile
RUN mkdir -p /root/.ssh && chmod 700 /root/.ssh/

# Command to run on container start
CMD ["fish"]