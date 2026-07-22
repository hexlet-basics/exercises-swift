#!/bin/bash

# Path to library
BUILD_PATH=/exercises-swift/src/.build/release

clean() {
  rm -f Run
}

# Compile test code and run
# Newer SwiftPM places the .swiftmodule under .build/release/Modules,
# while libHexletBasics.a stays in .build/release.
swiftc -o Run test.swift -I $BUILD_PATH -I $BUILD_PATH/Modules -L $BUILD_PATH -lHexletBasics
./Run

exit_code=$?

clean
exit $exit_code
