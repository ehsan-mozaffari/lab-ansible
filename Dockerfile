# syntax = docker/dockerfile:1.3
FROM python:3.9.18-alpine3.19

ENV ANSIBLE_VERSION 8.7.0
ENV ANSIBLE_LINT_VERSION 6.22.1

RUN apk --update --no-cache add \
  ca-certificates \
  openssh-client \
  openssl \
  git\
  && pip3 install --no-cache-dir --upgrade pip \
  && pip3 install --no-cache-dir ansible ansible-lint \
  && rm -rf /var/cache/apk/* \
  && find /usr/lib/ -name '__pycache__' -print0 | xargs -0 -n1 rm -rf \
  && find /usr/lib/ -name '*.pyc' -print0 | xargs -0 -n1 rm -rf
# iputils \ # for ping
# alpine-sdk \ # all essential tools


# Collecting ansible
#   Downloading ansible-8.7.0-py3-none-any.whl.metadata (7.9 kB)
# Collecting ansible-lint
#   Downloading ansible_lint-6.22.1-py3-none-any.whl.metadata (7.5 kB)
# Collecting ansible-core~=2.15.7 (from ansible)
#   Downloading ansible_core-2.15.8-py3-none-any.whl.metadata (7.0 kB)
# Collecting ansible-compat>=4.1.10 (from ansible-lint)
#   Downloading ansible_compat-4.1.10-py3-none-any.whl.metadata (2.8 kB)
# Collecting black>=22.8.0 (from ansible-lint)
#   Downloading black-23.12.1-py3-none-any.whl.metadata (68 kB)

# RUN mkdir -p /etc/ansible \
#   && echo 'localhost' > /etc/ansible/hosts \
#   && echo -e """\
# \n\
# Host *\n\
#     StrictHostKeyChecking no\n\
#     UserKnownHostsFile=/dev/null\n\
# """ >> /etc/ssh/ssh_config

WORKDIR /ansible

SHELL [ "/bin/ash" ]

# CMD [ "ansible-playbook", "--version" ]

