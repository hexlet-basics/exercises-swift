FROM hexletbasics/base-image:latest

RUN wget -q https://swift.org/builds/swift-5.5-release/ubuntu2004/swift-5.5-RELEASE/swift-5.5-RELEASE-ubuntu20.04.tar.gz
RUN tar xzf swift-5.5-RELEASE-ubuntu20.04.tar.gz
RUN mv swift-5.5-RELEASE-ubuntu20.04 /usr/local/swift
RUN rm swift-5.5-RELEASE-ubuntu20.04.tar.gz

ENV PATH=/usr/local/swift/usr/bin:$PATH

WORKDIR /exercises-swift

COPY . .

ENV PATH=/exercises-swift/bin:$PATH
