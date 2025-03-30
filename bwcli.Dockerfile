# syntax=docker/dockerfile:1.2
FROM debian:trixie-slim

ARG BW_PLATFORM=linux
RUN apt-get update && apt-get install -y curl unzip ca-certificates && rm -rf /var/lib/apt/lists/*

RUN echo "Downloading Bitwarden CLI for platform: ${BW_PLATFORM}" && \
    curl -L -o /tmp/bw.zip "https://vault.bitwarden.com/download/?app=cli&platform=${BW_PLATFORM}" && \
    unzip /tmp/bw.zip -d /usr/local/bin/ && \
    chmod +x /usr/local/bin/bw && \
    rm /tmp/bw.zip

ENTRYPOINT ["/usr/local/bin/bw"]
CMD ["--help"]
