#!/bin/bash

# Path to library
BUILD_PATH=/exercises-swift/src/.build/release

clean() {
  rm -f Run
}

# Compile test code and run
swiftc -o Run test.swift -I $BUILD_PATH -L $BUILD_PATH -lHexletBasics
./Run

exit_code=$?

clean
exit $exit_code
