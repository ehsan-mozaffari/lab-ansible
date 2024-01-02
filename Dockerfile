# syntax = docker/dockerfile:1.3
FROM alpine:20231219

RUN apk --update --no-cache add \
  ca-certificates=20230506-r0 \
  openssh-client=9.6_p1-r0 \
  openssl=3.1.4-r2 \
  git=2.43.0-r0 \
  ansible=8.6.1-r0 \
  ansible-lint=6.22.1-r0 \
  && rm -rf /tmp/* \
  && rm -rf /var/cache/apk/* \
  && find /usr/lib/ -name '__pycache__' -print0 | xargs -0 -n1 rm -rf \
  && find /usr/lib/ -name '*.pyc' -print0 | xargs -0 -n1 rm -rf

WORKDIR /workspace

ENTRYPOINT ["/bin/ash"]