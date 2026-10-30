FROM curlimages/curl@sha256:3b8fde20978e330b401837f24b871ebe2c8d14ff7f07b87990bcd832588a1a75 AS download
ARG BOWLINE_RELEASE=pre-release-20260209
ARG BOWLINE_SHA256=2abdf808e8ad04df6593310759231fb577ffade8e40c691bc2c572b4936958af
WORKDIR /tmp
RUN curl --fail --location --retry 3 --output bowline \
      "https://github.com/iijlab/dnsext/releases/download/${BOWLINE_RELEASE}/bowline-linux-amd64" \
    && echo "${BOWLINE_SHA256}  bowline" | sha256sum -c - \
    && chmod 0555 bowline

FROM debian@sha256:a3bba7dc7dbcc1f37c2856c51fc9a7fac96608f50cb87b1b4e4d8b8c85ae988e
ARG BOWLINE_RELEASE=pre-release-20260209
LABEL org.opencontainers.image.source="https://github.com/konoe-akitoshi/dnsext" \
      org.opencontainers.image.title="Bowline for Kubernetes" \
      org.opencontainers.image.version="${BOWLINE_RELEASE}" \
      org.opencontainers.image.description="Verified upstream amd64 Bowline binary; non-root, unprivileged DNS port"
RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates libgmp10 zlib1g bind9-dnsutils \
    && rm -rf /var/lib/apt/lists/*
COPY --from=download /tmp/bowline /usr/local/bin/bowline
COPY --chmod=0555 health.sh /usr/local/bin/bowline-health
COPY bowline.conf root.keys /etc/bowline/
USER 65534:65534
EXPOSE 1053/udp 1053/tcp
HEALTHCHECK --interval=10s --timeout=3s CMD ["/usr/local/bin/bowline-health"]
ENTRYPOINT ["/usr/local/bin/bowline"]
CMD ["/etc/bowline/bowline.conf"]
