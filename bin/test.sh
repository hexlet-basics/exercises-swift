#!/bin/bash

# Provide library
PATH_TO_SRC=/exercises-swift/src
(
  cd $PATH_TO_SRC
  swift build -c release
)

# Compile test code and run
swiftc -o Run test.swift -I $PATH_TO_SRC/.build/release -L $PATH_TO_SRC/.build/release -lHexletBasics
chmod u+x ./Run
./Run 2>&1
rm Run
