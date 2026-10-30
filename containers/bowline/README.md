# Bowline container for Kubernetes

This fork packages the upstream Linux amd64 release `pre-release-20260209`.
The upstream binary SHA-256 and both build/runtime base images are pinned in
the Dockerfile. Runtime Debian packages are installed from the Debian repository
at build time; this is not a claim of bit-for-bit reproducible package resolution.
No executable is downloaded when a Pod starts.

The process runs as uid/gid 65534 on TCP/UDP 1053 with all capabilities dropped
and a read-only root filesystem. Mount a configuration directory at
`/etc/bowline`; include `health.invalid. A 127.0.0.1` for the supplied health probe.
Root DNSSEC trust anchors are included from IANA. Keep them current on image/config
updates; this image does not claim persistent RFC 5011 state management.

```
docker build -t bowline-k8s containers/bowline
docker run --rm --read-only --cap-drop ALL --security-opt no-new-privileges \
  -p 1053:1053/udp -p 1053:1053/tcp bowline-k8s
```

For Kubernetes, expose TCP/UDP 53 through a Service and use `targetPort: 1053`.
Use `exec: ["/usr/local/bin/bowline-health"]` as a readiness/liveness probe.
Manage ACLs at the network/service boundary: the upstream configuration supplied
here is not an Internet-facing open resolver policy. Encrypted DNS and the monitor
Web API are disabled. `/metrics` must not be exposed by enabling every Web API
operation without additional access control.

The build workflow publishes `ghcr.io/konoe-akitoshi/bowline-k8s` on main updates.
New GitHub packages may initially be private. Verify anonymous pull before using
the image without an imagePullSecret, then pin the published digest in deployments.

No home network settings, credentials, or private infrastructure manifests belong
in this public fork.
