FROM hexletbasics/base-image:latest

ARG SWIFT_VERSION=6.1.3
ARG SWIFT_PLATFORM=debian12

# Runtime + build dependencies for the Swift toolchain (Debian 12 / bookworm)
RUN apt-get update && apt-get install -y --no-install-recommends \
    binutils \
    libicu-dev \
    libcurl4-openssl-dev \
    libedit-dev \
    libsqlite3-dev \
    libncurses-dev \
    libpython3-dev \
    libxml2-dev \
    pkg-config \
    uuid-dev \
    tzdata \
    git \
    gcc \
    libstdc++-12-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Swift toolchain into /usr/local/swift (path hardcoded in Process+Test.swift)
RUN set -e; \
    case "$(dpkg --print-architecture)" in \
      amd64) SUFFIX='' ;; \
      arm64) SUFFIX='-aarch64' ;; \
      *) echo "unsupported arch: $(dpkg --print-architecture)" >&2; exit 1 ;; \
    esac; \
    REL="swift-${SWIFT_VERSION}-RELEASE"; \
    DIR="${REL}-${SWIFT_PLATFORM}${SUFFIX}"; \
    URL="https://download.swift.org/swift-${SWIFT_VERSION}-release/$(echo ${SWIFT_PLATFORM} | tr -d .)${SUFFIX}/${REL}/${DIR}.tar.gz"; \
    wget -q "$URL"; \
    tar xzf "${DIR}.tar.gz"; \
    mv "${DIR}" /usr/local/swift; \
    rm "${DIR}.tar.gz"

ENV PATH=/usr/local/swift/usr/bin:$PATH

WORKDIR /exercises-swift

COPY src src
RUN cd src && swift build -c release

COPY . .

ENV PATH=/exercises-swift/bin:$PATH
