#!/bin/sh

# Provide library
RELATIVE_PATH_TO_SRC=../../../src
(
  cd $RELATIVE_PATH_TO_SRC
  swift build -c release
)

# Compile test code and run
swiftc -o Run test.swift -I $RELATIVE_PATH_TO_SRC/.build/release -L $RELATIVE_PATH_TO_SRC/.build/release -lHexletBasics
chmod u+x ./Run
./Run 2>&1
rm Run
