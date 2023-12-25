# syntax = docker/dockerfile:1.3
FROM python:3.9.18-alpine3.19

ENV ANSIBLE_VERSION 8.7.0
ENV ANSIBLE_LINT_VERSION 6.22.1

RUN apk --update --no-cache add \
  ca-certificates=20230506-r0 \
  openssh-client=9.6_p1-r0 \
  openssl=3.1.4-r2 \
  git=2.43.0-r0 \
  && pip3 install --no-cache-dir ansible==${ANSIBLE_VERSION} ansible-lint==${ANSIBLE_LINT_VERSION} \
  && rm -rf /var/cache/apk/* \
  && find /usr/lib/ -name '__pycache__' -print0 | xargs -0 -n1 rm -rf \
  && find /usr/lib/ -name '*.pyc' -print0 | xargs -0 -n1 rm -rf

WORKDIR /workspace

