# FROM hexletbasics/base-image:latest
# swift with ubuntu:20.04 as base
FROM swift:focal

# From base-image
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV DEBIAN_FRONTEND noninteractive

ENV INVALIDATE_CACHE 1

RUN apt-get update
RUN apt-get install -yqq \
  git curl python3-pip libyaml-dev zip unzip jq software-properties-common wget
RUN pip3 install yamllint yq
RUN curl -sL https://deb.nodesource.com/setup_17.x | bash - && apt-get install -y nodejs
RUN npm install -g ajv-cli
COPY ./common /opt/basics/common
# End

WORKDIR /exercises-swift

COPY . .

ENV PATH=/exercises-swift/bin:$PATH

# Print Installed Swift Version
RUN swift --version