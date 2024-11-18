# Declare a build argument with a default value
ARG BASE_IMAGE=alpine:3.20
# Use the build argument as the base image
FROM ${BASE_IMAGE} AS runtime

# Set environment variables for UiPath CLI
ARG UIPATH_CLI_VERSION=latest
ARG OS=linux
ARG ARCH=arm64
ARG UIPATH_CLI_URL=https://github.com/UiPath/uipathcli/releases/$UIPATH_CLI_VERSION/download/uipathcli-$OS-$ARCH.tar.gz

# Install necessary dependencies and download UiPath CLI
RUN apk add --no-cache bash curl tar \
    && curl -sL "$UIPATH_CLI_URL" | tar -xzv -C /usr/local/bin \
    && chmod +x /usr/local/bin/uipath

# Create a non-root user and group
RUN addgroup -S uipathgroup && adduser -S uipathuser -G uipathgroup

# Switch to non-root user
USER uipathuser

# Set the working directory
WORKDIR /home/uipathuser

# Set the default entrypoint to UiPath CLI
ENTRYPOINT ["/bin/sh"]
