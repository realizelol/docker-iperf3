# base image
ARG VCS_REF
ARG BUILD_DATE
ARG ARCH=amd64
FROM alpine:latest

# environment
ENV LANG="en_US.UTF-8"
ENV PREFIX="/usr/local/bin"

# labels
LABEL maintainer="realizelol" \
  org.label-schema.schema-version="1.0" \
  org.label-schema.name="realizelol/docker-iperf3" \
  org.label-schema.description="Alpine Docker iperf3 server" \
  org.label-schema.version="1.0.0" \
  org.label-schema.url="https://hub.docker.com/r/realizelol/iperf3" \
  org.label-schema.vcs-url="https://github.com/realizelol/docker-iperf3" \
  org.label-schema.vcs-ref="${VCS_REF}" \
  org.label-schema.build-date="${BUILD_DATE}"

# copy scripts
COPY docker-entrypoint.sh "${PREFIX}/docker-entrypoint.sh"
RUN  chmod +x "${PREFIX}"/docker-*.sh

# download via repo + upgrade
RUN apk update && \
    apk add -u iperf3 && \
    apk upgrade -a --prune && \
    apk -v cache purge && \
    sync

# ports
EXPOSE 5201/tcp 5201/udp

# healthcheck
#HEALTHCHECK --timeout=3s \
#  CMD iperf3 -k 1 -c 127.0.0.1 || exit 1

# entrypoint
ENTRYPOINT "${PREFIX}/docker-entrypoint.sh" /usr/bin/iperf3 --server
