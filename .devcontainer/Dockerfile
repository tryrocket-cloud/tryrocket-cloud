# Use the official VS Code development container base image
FROM mcr.microsoft.com/vscode/devcontainers/base:debian

# Install Fish shell
RUN apt-get update && \
    apt-get install -y fish && \
    apt-get clean -y

# Set the default shell to Fish
SHELL ["/usr/bin/fish", "-c"]

# Create a user and set it up for VS Code
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

USER $USERNAME

# Ensure Fish shell is set as the default shell for the user
RUN sudo chsh -s /usr/bin/fish $USERNAME