FROM hexletbasics/base-image:latest

ARG V=5.5

RUN wget -q https://swift.org/builds/swift-${V}-release/ubuntu2004/swift-${V}-RELEASE/swift-${V}-RELEASE-ubuntu20.04.tar.gz
RUN tar xzf swift-${V}-RELEASE-ubuntu20.04.tar.gz
RUN mv swift-${V}-RELEASE-ubuntu20.04 /usr/local/swift
RUN rm swift-${V}-RELEASE-ubuntu20.04.tar.gz

ENV PATH=/usr/local/swift/usr/bin:$PATH

WORKDIR /exercises-swift

COPY src src
RUN cd src && swift build -c release

COPY . .

ENV PATH=/exercises-swift/bin:$PATH
